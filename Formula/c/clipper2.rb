class Clipper2 < Formula
  desc "Polygon clipping and offsetting library"
  homepage "https://github.com/AngusJohnson/Clipper2"
  url "https://github.com/AngusJohnson/Clipper2/releases/download/Clipper2_2.0.1/Clipper2_2.0.1.zip"
  sha256 "63e893fc40c3453c9d14cbe98bc7647f16a9d5846ae25b513d8a1ed5b8421144"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(/^Clipper2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "644de3fa5088f0f37d9d1d1530567896fef82371eaf7cb848e8114c3ae4974ca"
    sha256 cellar: :any,                 arm64_sequoia: "fa455f826081f9afa0964f14d73f607d2fc9853404a15f26f2aa8c7b12650c34"
    sha256 cellar: :any,                 arm64_sonoma:  "67363d807e6023dfbf747be4c4dc1a6499d64c581ed7ab7fe4b83edcd6d88975"
    sha256 cellar: :any,                 sonoma:        "cf100e91f23707d6e3e0d6689699d728e7cdcd841d3e980086af70ae92b2dff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff4c9f1e061afb3bd3c4c9920b0dc76562cb21edb4dbd7ddcaa76e88a061047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a77a2e151b24edfbb6e18bdb1f6b00d53ab552e40532f021490a02e0c1d9f1"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCLIPPER2_EXAMPLES=OFF
      -DCLIPPER2_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-S", "CPP", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "CPP/Examples/SimpleClipping/SimpleClipping.cpp" do |s|
      s.gsub! "\"../../Utils/clipper.svg.h\"", "\"clipper.svg.h\""
      s.gsub! "\"../../Utils/clipper.svg.utils.h\"", "\"clipper.svg.utils.h\""
    end

    pkgshare.install "CPP/Examples/SimpleClipping/SimpleClipping.cpp",
                     "CPP/Utils/clipper.svg.cpp",
                     "CPP/Utils/clipper.svg.h",
                     "CPP/Utils/clipper.svg.utils.h"
  end

  test do
    system ENV.cxx, pkgshare/"SimpleClipping.cpp", pkgshare/"clipper.svg.cpp",
                    "-std=c++17", "-I#{include}", "-L#{lib}", "-lClipper2",
                    "-o", "test"
    system "./test"
    refute_empty (testpath/"Intersect Paths.SVG").read
  end
end
