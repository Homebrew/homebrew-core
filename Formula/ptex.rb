class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex.git",
      tag:      "v2.4.0",
      revision: "5fa7d84337f072f8a842403c63e6a6a44b66e898"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6bc413bd95a1879fa2daba0856f1465c0d552b90f44c8a3a687ee636f472bfed"
    sha256 cellar: :any, big_sur:       "24e834b17833b7a914fcdf930563b88e8c7dc014a80cb0bb46b993df0e4bf9d0"
    sha256 cellar: :any, catalina:      "a5b92d4df049d129184563a0a2e8573a06ba3ac986f619e171cd92d95df911f7"
    sha256 cellar: :any, mojave:        "d4b13f11d4056ea7fe95a4de42850a03ca26bb78fea17633cdf3c429e4e38467"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  resource "wtest" do
    url "https://raw.githubusercontent.com/wdas/ptex/v2.4.0/src/tests/wtest.cpp"
    sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
  end

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("wtest").stage testpath
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-L#{opt_lib}", "-lptex"
    system "./wtest"
    system "#{bin}/ptxinfo", "-c", "test.ptx"
  end
end
