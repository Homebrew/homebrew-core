class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://github.com/MusicPlayerDaemon/MPD"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  stable do
    url "https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.15.tar.gz"
    sha256 "d2865d8f8ea79aa509b1465b99a2b8f3f449fe894521c97feadc2dca85a6ecd2"

    # Compatibility with fmt 11
    patch do
      url "https://github.com/MusicPlayerDaemon/MPD/commit/3648475f871c33daa9e598c102a16e5a1a4d4dfc.patch?full_index=1"
      sha256 "5733f66678b3842c8721c75501f6c25085808efc42881847af11696cc545848e"
    end

    # Fix missing include
    patch do
      url "https://github.com/MusicPlayerDaemon/MPD/commit/e380ae90ebb6325d1820b6f34e10bf3474710899.patch?full_index=1"
      sha256 "661492a420adc11a3d8ca0c4bf15e771f56e2dcf1fd0042eb6ee4fb3a736bd12"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8a12b2f699b5e35306f0202e23a8e70c4d4c91afb31d69dffd52d7bd5d6c9d48"
    sha256 cellar: :any, arm64_sonoma:  "c075df5f4127773fd783ca601fe9c3db60aa44c258938c5d98f5ac2521e4f260"
    sha256 cellar: :any, arm64_ventura: "81a28f9ac47a7ced4f3478668c8e191b4f3dd3be8f79618ec92ed9676ac413f7"
    sha256 cellar: :any, sonoma:        "6e679a66d2b7620c4e17432701859b21aa702974380779f7cba8499a83544960"
    sha256 cellar: :any, ventura:       "ec80333810dcdc8404eeac11a94ed3ac9517dd7a6a73035a16bcd38b1b12474a"
    sha256               x86_64_linux:  "0686b5d3e7579ca2fa949fe9c85869a9808699eb58db6524fa73b5e4e3e03f73"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "chromaprint"
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "glib"
  depends_on "icu4c@75"
  depends_on "lame"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "libid3tag"
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
      -Dchromaprint=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dshout=enabled
      -Dupnp=pupnp
      -Dvorbisenc=enabled
      -Dwavpack=enabled
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
