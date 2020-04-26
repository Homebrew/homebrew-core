class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.4.tar.xz"
  sha256 "511b60daabf7543a01de06af07c8772290c6807cd53c42a8504960e978f3abea"

  bottle do
    cellar :any
    sha256 "f1552770fcb298f73659e8d0de8c9894ad16dca2389ef63c5c1b3cca3efa7890" => :catalina
    sha256 "23a386dd82b903a3d4409658ebf44b0d713bdae8896f0e5074b1b22c35b943c5" => :mojave
    sha256 "da86c5f94b640ec425ef0d8cae77d46c614e0d395903ddb01aa425f3b4cff00d" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
