class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://web.archive.org/web/20230506090801/https://www.musicpd.org/"
  url "https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.14.tar.gz"
  sha256 "3547237437368962c8a8bdec088a369a94ef66f7afc22f6fc0d643c1406bd533"
  license "GPL-2.0-or-later"
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "4684b5e5f938d42f5886654eefe1c93362d6bb750f4c498db3dd8e12075bf192"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a21b1f1b0d56d248df2f8ab332c4d70a41ea232136a9ffa7d91539e8308e2d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b641c81963a361820ddb9478a10ba2478874cb9ba1f00e05234f51c2d9e15abf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2df9d64db0154005420087258fefd1b3d835dc688679a2f7cf681a77d8feac5"
    sha256 cellar: :any,                 sonoma:         "3deb55d9aa3fc6e1d3ac2f2c23819976b4afe5823c242a40a59d65a60c4813b7"
    sha256 cellar: :any_skip_relocation, ventura:        "167be1c3a62175b460948a691a6aa49e8fcb454f6c57ee715db251278767577e"
    sha256 cellar: :any_skip_relocation, monterey:       "d3ed12ae6333ad367d4a1eb01aa6ac51909d02197d39c680d86f43bd083f64ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e925b63fdceb63410fb99ee89b6deca6c9aad74426e7c7a4da5edc9037d6768d"
    sha256                               x86_64_linux:   "f8488331afcf10558861c938b36346c8588fe3572ccc33819c5a2104fd1e23e4"
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
