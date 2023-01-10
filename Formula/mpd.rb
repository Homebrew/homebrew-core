class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  license "GPL-2.0-or-later"
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  stable do
    url "https://www.musicpd.org/download/mpd/0.23/mpd-0.23.11.tar.xz"
    sha256 "edb4e7a8f9dff238b5610f9e2461940ea98c727a5462fafb1cdf836304dfdca9"

    # Fix build with boost 1.81.0. Remove in the next release.
    patch do
      url "https://github.com/MusicPlayerDaemon/MPD/commit/e4b055eb6d08c5c8f8d85828ce4005d410e462cb.patch?full_index=1"
      sha256 "f22db9ef76aea9e24de079edcb6d2882a5285d82d4063ce30454347c6d3fd767"
    end
  end

  livecheck do
    url "https://www.musicpd.org/download.html"
    regex(/href=.*?mpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "60ae639c1148c13cdd74e8762bf649fdf78b4cd06fd063508f378856a6016bf6"
    sha256 cellar: :any, arm64_monterey: "751ae5a309944aeb1d286145e869c243415637066b69739f0cdeea966bcc55db"
    sha256 cellar: :any, arm64_big_sur:  "d29c7f724e8cb335436d8444e687c62691b8c64a6b3035efad2e27650cf11aa0"
    sha256 cellar: :any, ventura:        "ed1d36b6080eccdf6148dfc62584191e111c174f732a78c46a43141efca4209a"
    sha256 cellar: :any, monterey:       "2940005083ba1ed5969ba0d60ca46d6a1426f399b0941d694e080dc43eb4445d"
    sha256 cellar: :any, big_sur:        "92e54cddfc5efdfe5475354c5201ccbc56d287c8a55b4c298880c34d68c97547"
    sha256               x86_64_linux:   "3e99604a1667ec61152be2fc25b3c96e96060dd67bde0ba2a11577a6994c31ca"
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
