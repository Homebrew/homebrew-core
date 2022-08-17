class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.23/mpd-0.23.9.tar.xz"
  sha256 "2becaba980402e8dc7972ccc3476e493b7ae2eeb720d31fa6712472ed48e9f2d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  livecheck do
    url "https://www.musicpd.org/download.html"
    regex(/href=.*?mpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ccc125d2227cee747886f8cd48237030c1786a5764a968920f3ac0019c709cd8"
    sha256 cellar: :any, arm64_big_sur:  "c3cf0733c0cdad5de4776fb80a43344aee63b53a425d2fccabe353a1858e8881"
    sha256 cellar: :any, monterey:       "e5354918e03ff42d265ac3932e2b5ea579e10bc18ec956c1a2debae7e2cb5a84"
    sha256 cellar: :any, big_sur:        "336408524d2bab5a2ed5c1113baa580a90a970cd1c1e0146f4539fac76360f25"
    sha256 cellar: :any, catalina:       "a7b127c371d55ab32e9e58123b7019a8c3b5cfc0aad4eaf83927b823429f7ae8"
    sha256               x86_64_linux:   "b7b9a436bea570a3c0c4a3ff2c4684d9842282571f18cf8e136c40f1f74ed6e6"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "lame"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "libid3tag"
  depends_on "libmpdclient"
  depends_on "libnfs"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on macos: :mojave # requires C++17 features unavailable in High Sierra
  depends_on "opus"
  depends_on "sqlite"

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    args = %W[
      --sysconfdir=#{etc}
      -Dmad=disabled
      -Dmpcdec=disabled
      -Dsoundcloud=disabled
      -Dao=enabled
      -Dbzip2=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dshout=enabled
      -Dupnp=pupnp
      -Dvorbisenc=enabled
    ]

    system "meson", "setup", "output/release", *args, *std_meson_args
    system "meson", "compile", "-C", "output/release"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "meson", "install", "-C", "output/release"

    pkgetc.install "doc/mpdconf.example" => "mpd.conf"
  end

  def caveats
    <<~EOS
      MPD requires a config file to start.
      Please copy it from #{etc}/mpd/mpd.conf into one of these paths:
        - ~/.mpd/mpd.conf
        - ~/.mpdconf
      and tailor it to your needs.
    EOS
  end

  service do
    run [opt_bin/"mpd", "--no-daemon"]
    keep_alive true
    process_type :interactive
    working_dir HOMEBREW_PREFIX
  end

  test do
    # oss_output: Error opening OSS device "/dev/dsp": No such file or directory
    # oss_output: Error opening OSS device "/dev/sound/dsp": No such file or directory
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "expect"

    port = free_port

    (testpath/"mpd.conf").write <<~EOS
      bind_to_address "127.0.0.1"
      port "#{port}"
    EOS

    io = IO.popen("#{bin}/mpd --stdout --no-daemon #{testpath}/mpd.conf 2>&1", "r")
    io.expect("output: Successfully detected a osx audio device", 30)

    ohai "Connect to MPD command (localhost:#{port})"
    TCPSocket.open("localhost", port) do |sock|
      assert_match "OK MPD", sock.gets
      ohai "Ping server"
      sock.puts("ping")
      assert_match "OK", sock.gets
      sock.close
    end
  end
end
