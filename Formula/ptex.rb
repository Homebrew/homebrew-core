class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "664253b84121251fee2961977fe7cf336b71cd846dc235cd0f4e54a0c566084e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "007e9ec13d5fd24241631661d98ddadc06ed74023b24aa8f92d548890125c856"
    sha256 cellar: :any,                 arm64_big_sur:  "f724e08c9adfdc18a09822e58f59c9cada0397237623b204257c2e9a08526af9"
    sha256 cellar: :any,                 monterey:       "2edfb942d88372c8186527d8e57e3c031b031bab1b68cc72045b586dbc5ba745"
    sha256 cellar: :any,                 big_sur:        "876e14276688993618d4bcf794dfffea9362b514aa4a980ac8f570b1eab75d13"
    sha256 cellar: :any,                 catalina:       "86db27292915d7ecbfe5a2867e54be5b098f2a721ab9372cb3ae8435855df498"
    sha256 cellar: :any,                 mojave:         "26aa1f062d495a937a2e95e206f5b62fd16845d4eb09c1f49a073a6731cb4458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ab715f2512320577d58f5eb2d85ecc1d2fe19bc63046827ccc01983b7c0bf7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  resource "wtest" do
    url "https://raw.githubusercontent.com/wdas/ptex/v2.4.1/src/tests/wtest.cpp"
    sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
  end

  def install
    system "make", "prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("wtest").stage testpath
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end
