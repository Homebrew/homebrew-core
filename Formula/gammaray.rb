class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.3/gammaray-2.11.3.tar.gz"
  sha256 "03d7ca7bd5eb600c9c389d0cf071960330592f1f392a783b7fec5f9eaa5df586"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "3cc302e1f904652a114308302ed2b1e8b42f704963e62a3c2c288118f4545f85"
    sha256 cellar: :any, arm64_big_sur:  "bdf3eb554fd62c1f4fffb31049006fb6911b77f798adbc4e87061a5066e9b77d"
    sha256 cellar: :any, monterey:       "d99a1367c0a43a9e0a71b4fb6061ce6386d87612e41fba412990e433400dfecf"
    sha256 cellar: :any, big_sur:        "c2233705c3f3c5b0af61f67ebcd4c891313903c857a1a7773ab426ecd0e7acfb"
    sha256 cellar: :any, catalina:       "990a0bd03354b751b3913cc6b308beba880fef6c97898290420221d9f8a080fa"
    sha256 cellar: :any, mojave:         "3eeedcdccc07fc4dba59a90a3672f1a208fd608c6127839d5437019bfbd5adc6"
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
