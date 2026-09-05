class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "435c116ea5bbe6f0054f8227e204d255b2d91bf35786b007c77a894c729c1fbc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f6b18525e8aa4d1ab9e6298af2f8936b1e5218d52042767cbe6020d128e7a8f"
    sha256 cellar: :any, arm64_sequoia: "5e969c5567da054b3733a34e49c319350b444dd39c2d4e4b6ad32509b3be6e77"
    sha256 cellar: :any, arm64_sonoma:  "3a3a385bdc675b1813564046f2e76d9d8e866997eec6540e2722119952a4efa9"
    sha256 cellar: :any, arm64_linux:   "2bf692748c47808b22456a48df78bfe84678b645d1d7975561fc074ea133dd33"
    sha256 cellar: :any, x86_64_linux:  "539d9d46089ceb88ce4c0a4db1e9704063e479bc8785667dc7167f8e4d9bcd6d"
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
