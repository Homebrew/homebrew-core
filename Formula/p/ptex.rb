class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "c8235fb30c921cfb10848f4ea04d5b662ba46886c5e32ad5137c5086f3979ee1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7282fd8fe44376f04b4b3c1696a30f36f1bb150b9f2894a689ac456b8121620"
    sha256 cellar: :any,                 arm64_monterey: "c8166dbf7e60e50c6a602d9cd086c95d3ff6ffd174532195e06cc7b8ee4b5e5f"
    sha256 cellar: :any,                 arm64_big_sur:  "cd30bbf7d22f7cda90f8c3af76b4d9ff36a606384ba1f4c04859053a230c2b11"
    sha256 cellar: :any,                 ventura:        "de4e10f772f79cb92fdd3bd56d2e5d8d24eef5ffdaa81674215c6449bdaad812"
    sha256 cellar: :any,                 monterey:       "22a62f337bcab936818db4534f04b38615592278d8baba30cc14312c7646453b"
    sha256 cellar: :any,                 big_sur:        "21815b74081a6e0129e400f656a33ad927247ee228c1dec5e47a3affed08c8e6"
    sha256 cellar: :any,                 catalina:       "2793ce52bb20a2274fa5b3e4b69133150ee5b52a212edfc403985784f62601e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8e30dcd4ce82159021804cc0df50f24c4790e3ae72562968547abd6091ed440"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  resource "wtest" do
    url "https://raw.githubusercontent.com/wdas/ptex/v2.4.2/src/tests/wtest.cpp"
    sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("wtest").stage testpath
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end
