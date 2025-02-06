class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://github.com/MusicPlayerDaemon/MPD"
  license "GPL-2.0-or-later"
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  stable do
    url "https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.17.tar.gz"
    sha256 "6fcdc5db284297150734afd9b3d1a5697a29f6297eff1b56379018e31d023838"

    # support libnfs 6.0.0, upstream commit ref, https://github.com/MusicPlayerDaemon/MPD/commit/31e583e9f8d14b9e67eab2581be8e21cd5712b47
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/557ad661621fa81b5e6ff92ab169ba40eba58786/mpd/0.23.16-libnfs-6.patch"
      sha256 "e0f2e6783fbb92d9850d31f245044068dc0614721788d16ecfa8aacfc5c27ff3"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "799bd647c025d45fa87f12e653ed5e3bde8fa9796414a73dcb222d11927987c7"
    sha256 cellar: :any, arm64_sonoma:  "65f57b447ec88c7491464f42c918a1ba31f23151b7d997baa5050d5b0a6a011d"
    sha256 cellar: :any, arm64_ventura: "16a430b56f0a94e324317553d7439d227727c26270a68fa8ea74e88881437675"
    sha256 cellar: :any, sonoma:        "b046a55118013d7aa0a065327e7d5202823522b1866ef162c8f1e56f019b9fd7"
    sha256 cellar: :any, ventura:       "493c65b5cca1dae97bd4c73613a909e601fb338e359c41cecfb8f9218d72ad3c"
    sha256               x86_64_linux:  "b8317e93faa5a33f956969bbf06a645a1208c65b13568b5b8bcbc088db6ff9ea"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "chromaprint"
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "game-music-emu"
  depends_on "glib"
  depends_on "icu4c@76"
  depends_on "lame"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "libid3tag"
  depends_on "libmikmod"
  depends_on "libmpdclient"
  depends_on "libnfs"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on macos: :mojave # requires C++17 features unavailable in High Sierra
  depends_on "mpg123"
  depends_on "opus"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "wavpack"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "jack"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    # https://github.com/MusicPlayerDaemon/MPD/pull/2198
    inreplace "src/lib/nfs/meson.build", "['>= 4', '< 6']", "['>= 4']"

    args = %W[
      -Dcpp_std=c++20
      --sysconfdir=#{etc}
      -Dmad=disabled
      -Dmpcdec=disabled
      -Dsoundcloud=disabled
      -Dao=enabled
      -Dbzip2=enabled
      -Dchromaprint=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dshout=enabled
      -Dupnp=pupnp
      -Dvorbisenc=enabled
      -Dwavpack=enabled
      -Dgme=enabled
      -Dmikmod=enabled
      -Dsystemd_system_unit_dir=#{lib}/systemd/system
      -Dsystemd_user_unit_dir=#{lib}/systemd/user
    ]

    system "meson", "setup", "output/release", *args, *std_meson_args
    system "meson", "compile", "-C", "output/release", "--verbose"
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

    assert_match "[wavpack] wv", shell_output("#{bin}/mpd --version")

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
