class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.3.2.tar.gz"
  sha256 "e9ca24faddda92d03234b3a72dc00139e3d8dca562d78c8e723c45e8384e9fc7"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "452f1e65c59cc9918415c7b2ee2c8bd1ba378694fbbdfb39b31c8a807b2923b7"
    sha256 big_sur:       "b56c6373091094c2bcb7527a923d909a8ff69ce8a9483b68aea8d6d7fb020e17"
    sha256 catalina:      "7084c9669f3c220018c7538b7c8da52866c697443ab61e784a05c5f781baacd1"
    sha256 mojave:        "b936fe4b06b7ff9122ed41d8296b8382702e03695add97824645b350b7b3dcc5"
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
