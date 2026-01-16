class Lunasvg < Formula
  desc "SVG rendering and manipulation library in C++"
  homepage "https://github.com/sammycage/lunasvg"
  url "https://github.com/sammycage/lunasvg/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "1abf1472ee6c4d19797916e8cc3c2e4b628e0d81178ffac60bdb0d457e32c690"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ba4d114606c7abb635b3520f37ec4cb4ddd24c921d5b01086cd2a0c9cbea447"
    sha256 cellar: :any,                 arm64_sequoia: "499a9cabbbac89c833bb9761d8216939a695f7ce998da8fcb6783f33b92597ee"
    sha256 cellar: :any,                 arm64_sonoma:  "731dbc29fd57799e6c28e7412c187ed84818eafa98b2e4de54b3c79d72537e1e"
    sha256 cellar: :any,                 sonoma:        "62a69aaf4f59fe8d216d7ba3d114613d13cca88fcc82d001c8302821e3d026e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf5601203a5abc7c1b45ea80120d5a2f4e077cac9cb2f227929b67e14ef63cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3926b29e2b76ef27165734559a8f8cc6a6812be61e8c97c04055478e5fca7da9"
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
