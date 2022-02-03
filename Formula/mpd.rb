class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://www.musicpd.org/download/mpd/0.23/mpd-0.23.5.tar.xz"
  sha256 "f22c2c25093a05f4566f9cd7207cfbcd8405af67ed29a989bcf8905f80b7a299"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  livecheck do
    url "https://www.musicpd.org/download.html"
    regex(/href=.*?mpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "139504a6aaaf0d8de8904bfab7d8868043507bfde3be9dc7d6df8f2d464a1690"
    sha256 cellar: :any, arm64_big_sur:  "851248a94d02fff751d3abae449e2547c815495613574a62802e9e7168127957"
    sha256 cellar: :any, monterey:       "dc2d2a07d2cf7df5379bd9e87c4802b1bfb762f8fb49afc5260190086dd0235c"
    sha256 cellar: :any, big_sur:        "459685fa7bd8e5efd6f8af897d76884ebde38e72850767b00fe239f6935a7f25"
    sha256 cellar: :any, catalina:       "064067cfe031480090532ca96ab96613b5a6a7dc78cdcd74905dba5e1f7b322a"
    sha256               x86_64_linux:   "4cb581fea4408f9681d082e710223efded3e8471602b54761a2ec080a2c17512"
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
