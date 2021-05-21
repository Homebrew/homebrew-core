class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex.git",
      tag:      "v2.4.0",
      revision: "5fa7d84337f072f8a842403c63e6a6a44b66e898"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:     "4997e628df7475b72cc39127975c65354d89558d0a44f9e63315ddd4195858bd"
    sha256 cellar: :any, catalina:    "309b9d77d69b2797d9161c8bf93d13fbc48db114b4e308674bf208006ad4c571"
    sha256 cellar: :any, mojave:      "2c55851c7d65d7953fedeed3ca738b9ab80c0ef61a7239633d485fbde53fdb92"
    sha256 cellar: :any, high_sierra: "599291e5ea9a7972828818ac1e940ecbaca107f1ef36af556bf9de4c141fa5a8"
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
