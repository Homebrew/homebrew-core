class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://web.archive.org/web/20230506090801/https://www.musicpd.org/"
  url "https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.13.tar.gz"
  sha256 "c002fd15033d791c8ac3dcc009b728b0e8440ed483ba56e3ff8964587fe9f97d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "fa9cd11e5bbe4d9b30b3af5b39914b43946c145d83447b79ce51f9bab6c6da3a"
    sha256 cellar: :any, arm64_monterey: "66e53255d65450435c792e043ea312ba3cdb487df388ea5e3f767d7ace183f6f"
    sha256 cellar: :any, arm64_big_sur:  "06644e8bbbfe2db88880b5eff435abda354ab9b2ca71c1450eff958015e0efe2"
    sha256 cellar: :any, ventura:        "b34f0e6df048aeeaf16f89b5f3a5821b0bd26262459c5e33f9a5befd3ab2b67d"
    sha256 cellar: :any, monterey:       "8635a464ff00e30d4486b5d8bff9ce2a885f3cef5941d6084aef5bf29d2bb183"
    sha256 cellar: :any, big_sur:        "0fda32e1f629baaae537f2542ceeb5983a6a3e0b3807fcd8453be07d2d13a96a"
    sha256               x86_64_linux:   "f01776e8946de962cdd307cc73a1cac1ea8e9a9540a9677a4f5f614bf7cd35ee"
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
