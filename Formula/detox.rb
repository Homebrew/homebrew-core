class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.3.2.tar.gz"
  sha256 "e9ca24faddda92d03234b3a72dc00139e3d8dca562d78c8e723c45e8384e9fc7"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur: "5c2304611ca6dd59ead3215c0bd461398ebd13db33c6cb3dbb9ade840d33275a"
    sha256 arm64_big_sur: "40fe04379cce8ec7a853273ff45c2e2465a499d3b1806990d2fd916c21381abe"
    sha256 catalina: "8b7adbacb128f86a759f66f8117957b8ddb96c03f6731b3175a32e1d855f3b28"
    sha256 mojave: "9212051eb654c219095a938bb2b93cb4f951a1f6dc5a8d0c928c8f53e288610d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
