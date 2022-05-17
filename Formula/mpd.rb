class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.23/mpd-0.23.7.tar.xz"
  sha256 "960dcbac717c388f5dcc4fd945e3af19a476f2b15f367e9653d4c7a948768211"
  license "GPL-2.0-or-later"
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  livecheck do
    url "https://www.musicpd.org/download.html"
    regex(/href=.*?mpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "53d1e2e5265ae152438c0dd6bf7add88f97383651351050f7a240536a70ad282"
    sha256 cellar: :any, arm64_big_sur:  "c99d2f275d6f0412e8f0de48df6a43ffaf1b9c1fcb23bcac2b706c7a2313168c"
    sha256 cellar: :any, monterey:       "7ce24984d226d46a5312e5c44b850d2b69b03fee8acd2a5382310e6889aa922d"
    sha256 cellar: :any, big_sur:        "dca4d1c83bb289d68f0c3f1cda7abd0b7a8b65e4e8c49b2767cd3110f3565038"
    sha256 cellar: :any, catalina:       "05fdd73fba1d2a32f5e0c9643a470bb9df754a097a01ba6386788e3bd7fb5fb4"
    sha256               x86_64_linux:   "0b2ceadf8b29cc437da40f48e8f6d7c2d7a1210559c57577180c91b6d9c91905"
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

  # Fix missing header file (see https://github.com/MusicPlayerDaemon/MPD/issues/1530)
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/MusicPlayerDaemon/MPD/commit/c6f7f5777694c448aa42d17f88ab9cf2e3112dd0.patch?full_index=1"
    sha256 "17c03ecee2a8b91c1b114b2ab340878f6cec5fc28093ec6386f4d7ba47d8b909"
  end

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    args = std_meson_args + %W[
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

    system "meson", *args, "output/release", "."
    system "ninja", "-C", "output/release"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "ninja", "-C", "output/release", "install"

    (etc/"mpd").install "doc/mpdconf.example" => "mpd.conf"
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
