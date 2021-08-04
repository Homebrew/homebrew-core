class Jobber < Formula
  desc "Alternative to cron, with better status-reporting and error-handling"
  homepage "https://dshearer.github.io/jobber/"
  url "https://github.com/dshearer/jobber/archive/v1.4.4.tar.gz"
  sha256 "fd88a217a413c5218316664fab5510ace941f4fdb68dcb5428385ff09c68dcc2"
  license "MIT"
  head "https://github.com/dshearer/jobber.git"

  bottle do
    sha256 arm64_big_sur: "b7ae670b701b1ed169771f2bc34822a785614ad33827e049d5c7456c02cf3591"
    sha256 big_sur:       "d6b20d135d1f3c3a83bbef5a8bd75aee37bbf737731c6e0dc24dfdfbc0985bdd"
    sha256 catalina:      "f34fec60aef5e18cfc6f5bb8f1e0dbb00a866a01e3e0041d6c8e055ee7c4e27e"
    sha256 mojave:        "6bb3016d2f4200636cd51c237d04039b8bbf285d473acb37589e45fc602caf30"
    sha256 high_sierra:   "1fafbf17e64ac28355dd28758441f97fbe8b7e633bde0cf48a744918c281f8da"
    sha256 x86_64_linux:  "bc19ce8f05dbf03e3f40ea37bd27ccb9e49377ec3aae867547dce5fa3ee7b670"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--libexecdir=#{libexec}", "--sysconfdir=#{etc}",
      "--localstatedir=#{var}"
    system "make", "install"
  end

  plist_options startup: true
  service do
    run libexec/"jobbermaster"
    keep_alive true
    log_path var/"log/jobber.log"
    error_log_path var/"log/jobber.log"
  end

  test do
    (testpath/".jobber").write <<~EOS
      version: 1.4
      jobs:
        Test:
          cmd: 'echo "Hi!" > "#{testpath}/output"'
          time: '*'
    EOS

    fork do
      exec libexec/"jobberrunner", "#{testpath}/.jobber"
    end
    sleep 3

    assert_match "Hi!", (testpath/"output").read
  end
end
