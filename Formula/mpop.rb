class Mpop < Formula
  desc "POP3 client"
  homepage "http://mpop.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpop/mpop/1.2.5/mpop-1.2.5.tar.xz"
  sha256 "01612b5fc60dcbd5368b7cc2e0fce6c141c2e835d4646f8d7214d9898a901158"

  bottle do
    cellar :any
    sha256 "c3f3e66e47fc708a56cd54198bdec0359665d494e48a4a4c042bcf7fc864089f" => :el_capitan
    sha256 "52e4b659e035d1b1411a01868e97f57b425e53e4f1bc5bb12141e69b3f4df9c6" => :yosemite
    sha256 "203e16f3c4acfd0f7697f94eb8b1ec93848b8b29539abf2b4202fe5cb95cb88f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
