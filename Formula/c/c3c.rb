class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "ddd58fd47e8dd93e26876ddfcee68452bf316705c8a8f7e9888f189276a97ad6"
  license "LGPL-3.0-only"
  head "https://github.com/c3lang/c3c.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc7ac9842351b48dba5af46ec51ebf381960d9750aeb5be0d549b39e47ab5d9c"
    sha256 cellar: :any,                 arm64_ventura:  "723d1d8786972923fa4d348a0c85b9b55c2142da5e06c28941cca5f64bc8e085"
    sha256 cellar: :any,                 arm64_monterey: "6b6fae6212f860cf9b7f596dc0f1192640621e45e777a1ecb4bbe2fab20907a9"
    sha256 cellar: :any,                 sonoma:         "237c81935e6444d9d3e7f4c53a3230961d44dadadff52cda68df99a4a2c142c9"
    sha256 cellar: :any,                 ventura:        "945d10303b489b629b63089fc3cf951dde0ffe22760e87c901586aa80916afeb"
    sha256 cellar: :any,                 monterey:       "2dad700ad2d6cd8310fc4231deb351bb672d63bf8412e5e24b6cb71fcf01e03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "881de2f405355ef66f91b7aa0314c65a665e3b23948266a60ee95b81fdffa68e"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end
