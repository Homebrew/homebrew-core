class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "https://github.com/grobian/html2text"
  url "https://github.com/grobian/html2text/releases/download/v2.2.3/html2text-2.2.3.tar.gz"
  sha256 "859133528b3fd893562e41d84bc1ebc1f9166dd281d0fa8e17e7dd26337f5752"
  license "GPL-2.0-or-later"
  head "https://github.com/grobian/html2text.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0586df2ecd8a66280ec53b0ae852f22867471b66a60fbd4cb8054a1a2c98b536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03b77ee2ee4c1a68b990f2d386ddf70ff2f072da841441f2d4ae0aecf3e95f26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6b508a10d46399eaf5f9040974e1b91b1a9efb51d8bf1be3bdb04ca114b567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9ee670f7db4188a57c3c7dd563ef3bf45cb36dc90688d9d1f67ee28efc09ccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc46b8e76c5aed13521d92cf83e521142115ad206e6e6b7cba03b153ace328ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "558e4e7ad1247c5f25210a29fd458b82f5dcda8c36ca9e81db5385d9a21107b1"
    sha256 cellar: :any_skip_relocation, ventura:        "d5aaf31694d77a7b58638596ed3d0aa9bac50b148b60e416dd9cd41306fb2b86"
    sha256 cellar: :any_skip_relocation, monterey:       "f8a93138c8595992de8d0e9421147b1995d1f4344cf7f94b47f004c76ffe46e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4d67a9b09786e6f9e1141dd88a614493b94c65d47e87e6cecb9a65bcf8b353b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8fa522f9b7031aff66bb0bdabef05c4def2d153a7c6ff5f4136341b06822c5f"
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
