class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.2/gammaray-2.11.2.tar.gz"
  sha256 "bba4f21a2bc81ec8ab50dce5218c7a375b92d64253c690490a6fcb384c2ff9f3"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e8b81cc5071a41864b36ef1a1b5b78d22d9e6ca1dde3d6bc2b3cdd10f1fd29df"
    sha256 cellar: :any, big_sur:       "1dc9ceee5a0f4834575d40de389b9ef3ff5facc38dfbab719d0148fb485ce514"
    sha256 cellar: :any, catalina:      "1889bf702131e2e69bd5e98fd0d7506ce548c9dc0698ffed317363050fe230b3"
    sha256 cellar: :any, mojave:        "8db4edf69aca0f2ead6f5a400ec7a21c48e00f81b33f49b7ea1a5abf3185887c"
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt@5"

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
