class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/2.0.1.tar.gz"
  sha256 "365f052d5fb4419ed016394ddb26ab83dee6514b90565ad30af044a09b122aef"
  license "BSD-3-Clause"
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(/href=.*?ompl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e000a77945fbd5bd95799ef5d5fa961bfa94def6eeaca5b27f445cb3cc8abfa"
    sha256 cellar: :any, arm64_sequoia: "e8a19a344fddff584c95b7b72915de586c517f6a8c27a87a3350916971c234bd"
    sha256 cellar: :any, arm64_sonoma:  "ec2c1bd99389b032b8b482f9a78be798d89984c8d4847c93cac0b0ddc6bd430a"
    sha256 cellar: :any, sonoma:        "6ad7a9c1a99f1ea17d5b2639f18daad64fadd66921885ac5636829912e17ccde"
    sha256 cellar: :any, arm64_linux:   "adda85d7b46f075d4db02ee76e88ee3aacb3fa0dde58837e9a3ea46d244172a5"
    sha256 cellar: :any, x86_64_linux:  "a24bd68455b6a4cfd091627b23f214b5db000530def25f84d09a53ef0099c4cd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  def install
    args = %w[
      -DOMPL_REGISTRATION=OFF
      -DOMPL_BUILD_DEMOS=OFF
      -DOMPL_BUILD_TESTS=OFF
      -DOMPL_BUILD_PYBINDINGS=OFF
      -DOMPL_BUILD_PYTESTS=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-#{version.major_minor}", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end
