class Cmusfm < Formula
  desc "Last.fm standalone scrobbler for the cmus music player"
  homepage "https://github.com/Arkq/cmusfm"
  url "https://github.com/Arkq/cmusfm/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "17aae8fc805e79b367053ad170854edceee5f4c51a9880200d193db9862d8363"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c468424e8ac997b4023e2c7e4ec625080c97f2c9ddeadfc70736537abfeb0d9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ef65ce1fc192ca63fb9cf3e93bfe02e506d64e5ae3c0055bc78577a4426c621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9fbdb03148c3656857bbdfc833bd0514abaa472b75ffe143a0e042481758d17"
    sha256 cellar: :any,                 arm64_linux:       "d7a116d48c138e4f23cc4c5edbd71c7a79ead35cdfc81d792b7ac8ec6b7eef7b"
    sha256 cellar: :any,                 x86_64_linux:      "17ba2ee6eb8de213d46ddf46e0958225f814069f8b401b3a29c6b4b1d9f249c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfaketime" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    mkdir "build" do
      system "../configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    cmus_home = testpath/".config/cmus"
    cmusfm_conf = cmus_home/"cmusfm.conf"
    cmusfm_sock = cmus_home/"cmusfm.socket"
    cmusfm_cache = cmus_home/"cmusfm.cache"
    faketime_conf = testpath/".faketimerc"

    test_artist = "Test Artist"
    test_title = "Test Title"
    test_duration = 260
    status_args = %W[
      artist #{test_artist}
      title #{test_title}
      duration #{test_duration}
    ]

    mkpath cmus_home
    touch cmusfm_conf

    begin
      server = fork do
        faketime_conf.write "+0"
        if OS.mac?
          ENV["DYLD_INSERT_LIBRARIES"] = Formula["libfaketime"].lib/"faketime/libfaketime.1.dylib"
          ENV["DYLD_FORCE_FLAT_NAMESPACE"] = "1"
        else
          ENV["LD_PRELOAD"] = Formula["libfaketime"].lib/"faketime/libfaketime.so.1"
        end
        ENV["FAKETIME_NO_CACHE"] = "1"
        exec bin/"cmusfm", "server"
      end
      loop do
        sleep 0.5
        assert_nil Process.wait(server, Process::WNOHANG)
        break if cmusfm_sock.exist?
      end

      system bin/"cmusfm", "status", "playing", *status_args
      sleep 5
      faketime_conf.atomic_write "+#{test_duration}"
      system bin/"cmusfm", "status", "stopped", *status_args
    ensure
      Process.kill :TERM, server
      Process.wait server
    end

    assert_path_exists cmusfm_cache
    strings = shell_output "strings #{cmusfm_cache}"
    assert_match(/^#{test_artist}$/, strings)
    assert_match(/^#{test_title}$/, strings)
  end
end
