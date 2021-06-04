class Cmusfm < Formula
  desc "Last.fm standalone scrobbler for the cmus music player"
  homepage "https://github.com/Arkq/cmusfm"
  url "https://github.com/Arkq/cmusfm/archive/v0.4.0.tar.gz"
  sha256 "d72e04df69c1f3e95f1b7779f583a790660856fadb5cfd8a2717c085b1b12111"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8469d430a7f80f217b6c3fc18a94dd621031a99e1ad0c0a4625b2c6e897b2fd0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf89db2bf4bc6d4beb35f909c7b6f5d555618b0bd64f29970d16a935c233c651"
    sha256 cellar: :any_skip_relocation, catalina:      "ee559b020876516d44248b576176bf06fca2119ce0522cc373297f7425455037"
    sha256 cellar: :any_skip_relocation, mojave:        "354392dce04c448c932b74c983a832d8f21faf21ec4309cbe33dee4fdfbd5930"
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
    assert_match(/^#{test_artist}$/, strings)
    assert_match(/^#{test_title}$/, strings)
  end
end
