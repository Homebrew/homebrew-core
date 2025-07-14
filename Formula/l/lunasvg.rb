class Lunasvg < Formula
  desc "SVG rendering and manipulation library in C++"
  homepage "https://github.com/sammycage/lunasvg"
  url "https://github.com/sammycage/lunasvg/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "06045afc30dbbdd87e219e0f5bc0526214a9d8059087ac67ce9df193a682c4b3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16cfb6298fabbd5b71023ca7879b49bb1ee7bad1d91a540173ff02d3aa841b3f"
    sha256 cellar: :any,                 arm64_sonoma:  "a00160c03606ff6039d7b12401ce59cbd2fc2a8e63482c81112dec7828f357ab"
    sha256 cellar: :any,                 arm64_ventura: "d602df1f3d4d246808d22c49ecf81e4a696734811ef4b81b769f0d2c4680eb32"
    sha256 cellar: :any,                 sonoma:        "c8188f17b54572252d434d3e0bfb837826c355fa6fe141812da2430be501ea1f"
    sha256 cellar: :any,                 ventura:       "1db019fe6dccb91f02ba0ee9daf2866ea72aa6a86598b8fc83efde71b613ff87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae455197a5e27b7f38fb4dca0b2f7116966c3bd6df2dd2326e7e6f8d09efdbe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9e3d41f146637461633611a259c12cb20ae9715b0c04af654ecf1bc5b34a14"
  end

  depends_on "cmake" => :build
  depends_on "plutovg"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUSE_SYSTEM_PLUTOVG=ON
      -DLUNASVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/svg2png.cpp"
  end

  test do
    args = %W[
      -std=c++11
      -I#{include}/lunasvg
      -I#{Formula["plutovg"].opt_include}/plutovg
      -L#{lib}
      -L#{Formula["plutovg"].opt_lib}
      -llunasvg
      -lplutovg
    ]

    system ENV.cxx, pkgshare/"examples/svg2png.cpp", "-o", "svg2png", *args
    system testpath/"svg2png", test_fixtures("test.svg")
    assert File.size("test.svg.png").positive?
  end
end
