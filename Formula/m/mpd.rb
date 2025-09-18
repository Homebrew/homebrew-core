class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.24.5.tar.gz"
  sha256 "ab7f9a2315eff97cc47dff5da9b9c675b1764cd50f161dc295b8a0d1956a6244"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "cbfe018650e11d3a81504d13d046da9e368842f3834a76e0646bd28cc8cd254a"
    sha256 cellar: :any, arm64_sequoia: "c2ac996ca9c88223d47853c18508f295b52488b2d6b7d672f559701f200f8cf7"
    sha256 cellar: :any, arm64_sonoma:  "c10d610f17f0409b4306b6550e504e317f7d4563f15c22e84df868096a20569d"
    sha256 cellar: :any, arm64_ventura: "53d65b62f0b174eedb410986e7dc1dd1aafa82d220699f3d77339638b1f7b16b"
    sha256 cellar: :any, sonoma:        "91f79003f71d6952e7c7fe30df4e8e2f1b2617274468fdb40718c03a3fe99c22"
    sha256 cellar: :any, ventura:       "eb33cd55a20ebec97bfd2ad18e0f4275e3aa6f9e629423ac68d87c84eb2e8f4b"
    sha256               arm64_linux:   "ffa0fe888741c5d0cfe8158001d4388a9d245d62d8d3eb8f8e86d57ef0a0d6fa"
    sha256               x86_64_linux:  "0e0d3e46ebf13ee9fd08e79d227fda5353b77eea10fc3d345a54be12d1eba0dd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "chromaprint"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "game-music-emu"
  depends_on "icu4c@77"
  depends_on "lame"
  depends_on "libao"
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
  depends_on "mpg123"
  depends_on "opus"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "wavpack"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "Needs C++20 std::make_unique_for_overwrite"
    end
  end

  on_linux do
    depends_on "systemd" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "jack"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      remove_brew_expat
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    args = %W[
      --sysconfdir=#{etc}
      -Dmad=disabled
      -Dmpcdec=disabled
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
      -Dnlohmann_json=enabled
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
