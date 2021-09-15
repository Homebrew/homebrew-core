class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/fpart-1.2.0.tar.gz"
  sha256 "ced59d68236d960473b5d9481f3d0c083f10a7be806c33125cc490ef2c1705f8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5280983e1f01c6b66ad61cb100b2d84eef052143458d1fffeb611a1ed217ea96"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cb6d82cc44bd6e8c4155ce38eae3499c421c38e1fe2c0adee12b99b9b975221"
    sha256 cellar: :any_skip_relocation, catalina:      "86e086c356acb32a5c69d8f27426b73a766c7eb6afa685f06f9a23449aa14983"
    sha256 cellar: :any_skip_relocation, mojave:        "3530748c1b13e7c12ab59cb31d97bf0a86d01dda91676225d76bf0b209066bab"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2dda0b4cbd994c5017392eb43c870a85e7e567a0d13cba179a2786762067e7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd591a046e3ae01f92133747e6d76da5d71cf3236d09692736d0e73983ae691"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    (testpath/"mypart.0").exist?
    (testpath/"mypart.1").exist?
    !(testpath/"mypart.2").exist?
  end
end
