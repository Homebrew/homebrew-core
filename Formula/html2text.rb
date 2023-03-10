class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "https://github.com/grobian/html2text"
  url "https://github.com/grobian/html2text/archive/v2.1.1.tar.gz"
  sha256 "be16ec8ceb25f8e7fe438bd6e525b717d5de51bd0797eeadda0617087f1563c9"
  license "GPL-2.0-or-later"
  head "https://github.com/grobian/html2text.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6cdad48d7af587fb93c9190cdbfa1ef6e22eed8f48f98eae3fbe5f5d9d890d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54bba0f039b260d8cebd56ccb081dec77f1b75b11fc648a6dda6204b7bf21ccf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e60478802f517404cd7193c7ae612335fd2f4e494e8eb066badd9cf61dd72bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "2d2bf3c31c04bae55ddfcfe6e65ef9d955267d709dfa30192d33af43e8c4c685"
    sha256 cellar: :any_skip_relocation, monterey:       "195fd0fabd45c610163f7eb572e1aec8977b92150e1acc8dcc613c642ffc1dca"
    sha256 cellar: :any_skip_relocation, big_sur:        "051ceb5b6dc1a54670a01b6b90281b3f91a5e10c5f66d01db0f8664b78760e6d"
    sha256 cellar: :any_skip_relocation, catalina:       "2e2e2d60421b7b5609e5de0a8151abee3e4a4488f67cf4b6fed242cbbef4740b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b4f01b75211993397fa0a3fbe836c9817b331c2fcc5f01295a872961e88a0e0"
  end

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}", "BINDIR=#{bin}", "MANDIR=#{man}", "DOCDIR=#{doc}"
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
