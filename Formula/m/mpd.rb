class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://github.com/MusicPlayerDaemon/MPD"
  url "https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.15.tar.gz"
  sha256 "d2865d8f8ea79aa509b1465b99a2b8f3f449fe894521c97feadc2dca85a6ecd2"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "75aaa76bf8c7ca80c95031dca7edb2f5d2be3be5ca4497f892991af5f46c84e1"
    sha256 cellar: :any, arm64_ventura:  "edc7dc059af8a6e12743864c0c28350106562a28a97dd81d47c2be90a7a200e9"
    sha256 cellar: :any, arm64_monterey: "69357ae80afb04a5280ee467d0fb57b80a4c45e7ee52a34e1900ebb3b0a19ead"
    sha256 cellar: :any, sonoma:         "9b6fd7a48bca06aedc8b01189f34ede4885b128cd93b44b33a516b850c986dce"
    sha256 cellar: :any, ventura:        "3264fcec94c16f31feda5ae7811f7afe0ef7577694a6824b62af86360b19e4a4"
    sha256 cellar: :any, monterey:       "ab6395db650c07787ae9b76d68829abb7c8d651787ee4203b36a70f4f45472b0"
    sha256               x86_64_linux:   "42f7bdc9e0f5eea39128ac7c3af0f3aac59488bbc58b12ffae15633e3ea38b92"
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
  depends_on "wavpack"

  uses_from_macos "curl"

  on_linux do
    depends_on "systemd" => :build
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
