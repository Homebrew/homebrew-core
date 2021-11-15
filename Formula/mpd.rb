class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.22/mpd-0.22.11.tar.xz"
  sha256 "143f7f34aaee6e87888f3dd35d49aade6656052651b960ca42b46cbb518ca0a0"
  license "GPL-2.0-or-later"
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1b530b08224755e76ed13fe0a22c6f23fb274e650fbd3b46313da7ff7ebadfdd"
    sha256 cellar: :any, arm64_big_sur:  "db9228271af87d44a6158f10d8a6a2cf0a238d6e378212951ed5a8c577ac0726"
    sha256 cellar: :any, monterey:       "1338a11ed542b0fb1ea52555115a1da2f5d46e3d0e034f71ab59571de65f597b"
    sha256 cellar: :any, big_sur:        "47d7f2f993ef8b1a240f1e8a6d5cfa862a24f01d2f8b86305665f0108dda9697"
    sha256 cellar: :any, catalina:       "3ea0ab9f080ea931403df706f9c7cbd9a1a95381456063924c8cb8fdfc3b65b5"
    sha256 cellar: :any, mojave:         "6ea626d87bffeef1b4754e9822459132f1764ff34830642f473bf6f908efcfe5"
    sha256               x86_64_linux:   "21f148aada8fd8e69e802e5699f863f7bf272eb76f9103f4ba3071d2f7ff4f8e"
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
      -Dupnp=enabled
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
    on_linux do
      # oss_output: Error opening OSS device "/dev/dsp": No such file or directory
      # oss_output: Error opening OSS device "/dev/sound/dsp": No such file or directory
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

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
