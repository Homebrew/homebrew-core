class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "https://potrace.sourceforge.net/"
  url "https://potrace.sourceforge.net/download/1.16/potrace-1.16.tar.gz"
  sha256 "be8248a17dedd6ccbaab2fcc45835bb0502d062e40fbded3bc56028ce5eb7acc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?potrace[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f60557ba39e1e0bb436b79900bec393061141e8e73aa8b20cec3f3b95db69166"
    sha256 cellar: :any,                 arm64_sequoia: "c2ff921aca3ef95cfe62c72c080e78e5cf3628c13797391472aae7dd51e0d445"
    sha256 cellar: :any,                 arm64_sonoma:  "a7ff4e43e5e8772b091688b83e6c8d859a78b1e491161e022f49f90fcee1af58"
    sha256 cellar: :any,                 sonoma:        "d029f0be5c3488ee0505ab9007c421d7028da1cd92ef677c9526323594f9e7e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8fa204329840a3d30ac7b01a350675dfc3fb3d35b63e49fe4066c086d0aaf19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae69c21ad7fef2bac8e10969569948da925bf7266e3939ed02349fd85ae7f42"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "head.pbm" do
    url "https://potrace.sourceforge.net/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--mandir=#{man}",
                          "--with-libpotrace",
                          *std_configure_args
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system bin/"potrace", "-o", "test.eps", "head.pbm"
    assert_path_exists testpath/"test.eps"
  end
end
