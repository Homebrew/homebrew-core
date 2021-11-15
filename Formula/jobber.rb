class Jobber < Formula
  desc "Alternative to cron, with better status-reporting and error-handling"
  homepage "https://dshearer.github.io/jobber/"
  url "https://github.com/dshearer/jobber/archive/v1.4.4.tar.gz"
  sha256 "fd88a217a413c5218316664fab5510ace941f4fdb68dcb5428385ff09c68dcc2"
  license "MIT"
  head "https://github.com/dshearer/jobber.git"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "14087e07df78fd1e53fa44cc873df0db56eee9b0c89154161ee1a4c617c8ae9d"
    sha256 arm64_big_sur:  "c751dfdc4e8a2336eb4441dde62d3fc83d8ca869fe95e4804cecb99112551361"
    sha256 monterey:       "d54b324e8914c637f54418851308b825241d2c3142c8c13e9a6316ff31ab6e99"
    sha256 big_sur:        "669af998fd35ba85849f725ba8360cffbadfba87a8bd5f7adc43aa3a830caba5"
    sha256 catalina:       "993170495768a40b7f86927bfc14a66397b9109c3d9520815727f0123409b1e0"
    sha256 mojave:         "3767f3c9fa38a4ad1d8df745f8e5451bef3fea39e0f758a081e414f7d87feafa"
    sha256 x86_64_linux:   "e8d9630a84c0fce0514498c0379961df72d461ad3eb2d82847b66ea34732188c"
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
