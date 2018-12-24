class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.10.0/gammaray-2.10.0.tar.gz"
  sha256 "0554e43067c2eba3517cf746a921385cf15675db79f879e1c3a7851c4951ffbe"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    cellar :any
    sha256 "38093769a703351f1298dc84ebde0b8200b2f164fcb5d33cb89642e2ce239eee" => :mojave
    sha256 "6fdd21a02f532fb58d3e0cfe535274366b3351f9feaac26dffe9affea2846df7" => :high_sierra
    sha256 "a8f3ab656767e132b97b772d716db309316802dce79d0440568e5d0789b1bac7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  needs :cxx11

  def install
    # For Mountain Lion
    ENV.libcxx

    system "cmake", *std_cmake_args,
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF"
    system "make", "install"
  end

  test do
    assert_predicate prefix/"GammaRay.app/Contents/MacOS/gammaray", :executable?
  end
end
