class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "dd95fbea4b50e9e68fd042f540fb83157a0ff25053066c3439d4527de3621d34"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4f099c6edc4ecbad03908454937754e8c8f6c305e26c81c2f7076691cca8988"
    sha256 cellar: :any,                 arm64_sequoia: "d2b785dd36c29c9134a6df5a3f63b259af2512472db0386732fef6a697211fda"
    sha256 cellar: :any,                 arm64_sonoma:  "9eea79e8534259ecaa6ba343b5420ebd09a10121cbae8788239ea88c0f41b4c1"
    sha256 cellar: :any,                 sonoma:        "bd517a22c4b204d6f8017c572bdac202afd99d6138338de08b99090d4cd49e2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "997872daabf6c5f28913f179499df3a0a9ff6368863ec5da47302a6cc9bad964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "382a10a67ae55b7fb623010561ada1e635976223370d361a33e7ded6123078ed"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libdeflate"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-wtest" do
      url "https://raw.githubusercontent.com/wdas/ptex/v2.4.2/src/tests/wtest.cpp"
      sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
    end

    testpath.install resource("homebrew-wtest")
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end
