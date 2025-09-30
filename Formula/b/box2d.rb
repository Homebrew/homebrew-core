class Box2d < Formula
  desc "2D physics engine for games"
  homepage "https://box2d.org"
  url "https://github.com/erincatto/box2d/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "fb6ef914b50f4312d7d921a600eabc12318bb3c55a0b8c0b90608fa4488ef2e4"
  license "MIT"
  head "https://github.com/erincatto/Box2D.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e95ece003153c1a1124100c94a3c761e7b2e704551dc088d8062c97c94456cc0"
    sha256 cellar: :any,                 arm64_sequoia: "1caaf1c980effd48d3eed26366c13660960a289ac51526b68816679f6284631a"
    sha256 cellar: :any,                 arm64_sonoma:  "c5ad8a041d04cbefb6674fe3d3337bdcdf451cb7ef311894ff6014245ce7b658"
    sha256 cellar: :any,                 arm64_ventura: "c3eb47d52d68d2dea3679cf170ec01746dedc77bfc77386d6beb04ad29af28a5"
    sha256 cellar: :any,                 sonoma:        "37aa98eb7c538baac562620e3aed1187e0d23c713d73c8ec4c2def5c340d049b"
    sha256 cellar: :any,                 ventura:       "143f1e6e3f276f9e7ec87ea5d8b6f5056ac0388ad9f65c20998d16886e7a51f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c7471357570866b88743c8207c45e190e9478ecd7a0c44fbaf0bb603015df95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36086574d8eb78f65b8c94dc4ae1b94e9df18356c2636bf91b3a3bbffcc4805b"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBOX2D_UNIT_TESTS=OFF
      -DBOX2D_SAMPLES=OFF
      -DBOX2D_BENCHMARKS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <box2d/base.h>

      int main() {
        b2Version version = b2GetVersion();
        std::cout << "Box2D version: " << version.major << "." << version.minor << "." << version.revision << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lbox2d", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
