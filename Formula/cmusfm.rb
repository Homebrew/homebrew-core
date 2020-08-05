class Cmusfm < Formula
  desc "Last.fm standalone scrobbler for the cmus music player"
  homepage "https://github.com/Arkq/cmusfm"
  url "https://github.com/Arkq/cmusfm/archive/v0.3.3.tar.gz"
  sha256 "9d9fa7df01c3dd7eecd72656e61494acc3b0111c07ddb18be0ad233110833b63"

  bottle do
    cellar :any_skip_relocation
    sha256 "c27aa49951efe2e485aba1eaf9527387e2fa92472bd2c1f56b5097a021dc5a64" => :catalina
    sha256 "9e3320b2be61e18a10e6fef43c2c233b03670425108085c7aafa1218588cb2c9" => :mojave
    sha256 "8fc5c21846193c1187440c297d0cebdd86a83452e5c648eb9e6e813cb2385f4e" => :high_sierra
    sha256 "f399ae3146fe9e2214e24c96ecfbd3c77866a68c692d9d60d3363ac27d39da26" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libfaketime" => :test

  def install
    system "autoreconf", "--install"
    mkdir "build" do
      system "../configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--disable-silent-rules"
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
        ENV["DYLD_INSERT_LIBRARIES"] = Formula["libfaketime"].lib/"faketime"/"libfaketime.1.dylib"
        ENV["DYLD_FORCE_FLAT_NAMESPACE"] = "1"
        ENV["FAKETIME_NO_CACHE"] = "1"
        exec bin/"cmusfm", "server"
      end
      loop do
        sleep 0.5
        assert_equal nil, Process.wait(server, Process::WNOHANG)
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

    assert_predicate cmusfm_cache, :exist?
    strings = shell_output "strings #{cmusfm_cache}"
    assert_match /^#{test_artist}$/, strings
    assert_match /^#{test_title}$/, strings
  end
end
