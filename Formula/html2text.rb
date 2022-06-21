class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "http://www.mbayer.de/html2text/"
  url "https://github.com/grobian/html2text/archive/v2.1.1.tar.gz"
  sha256 "be16ec8ceb25f8e7fe438bd6e525b717d5de51bd0797eeadda0617087f1563c9"
  license "GPL-2.0"
  head "https://github.com/grobian/html2text.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e78419657ce5e06388abd3a41ec0322383aca2c2c71b2e45139ca78832d452f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c148cd0d5d064c8ad263ca7c12c9e4a73ce3ff5d1f9feebca0009e4a41add25"
    sha256 cellar: :any_skip_relocation, monterey:       "bd43224481e6120f6f304b1861e514fdf4571d1f5b558c86827d55ada0682fbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f8d47270e3e7f0fdbb628cac56a9da064c70de4f1988a6dec2985bb5e5235f9"
    sha256 cellar: :any_skip_relocation, catalina:       "5a236441829b3eaa51e021fda8e10bac0dc8b8ad80fa95fb268a7f21be18864c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97fe7d5f5d6188936ffc827e284fd438cacf7d08a4bd0590d3724284b0f40eba"
  end

  def install
    ENV.cxx11

    system "./configure"
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    path = testpath/"index.html"
    path.write <<~EOS
      <!DOCTYPE html>
      <html>
        <head><title>Home</title></head>
        <body><p>Hello World</p></body>
      </html>
    EOS

    output = `#{bin}/html2text #{path}`.strip
    assert_equal "Hello World", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
