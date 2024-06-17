class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "ddd58fd47e8dd93e26876ddfcee68452bf316705c8a8f7e9888f189276a97ad6"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/c3lang/c3c.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a77004e70884a4349b254f93f4e1d62540c324db2529f8c963c397d04fc2a277"
    sha256 cellar: :any,                 arm64_ventura:  "1c6e08be1094c3cd7ce49d9843c29ce7385dfa1ffd89233af79ff37ced053012"
    sha256 cellar: :any,                 arm64_monterey: "f1eba6d851f89a8c95e9aec69add604da9e0689f3784fc37b81c798bb78e0423"
    sha256 cellar: :any,                 sonoma:         "e1ccb43aae344db294cb8b246688ee0c7d0831c7c9e8a17f41516793dcc554f0"
    sha256 cellar: :any,                 ventura:        "b3de2bf58e3af77f89aa0f2e6c7ea9f53d9d318d3f3471d0ef856acc2e3c186d"
    sha256 cellar: :any,                 monterey:       "412bfde4a57752a14456717b13f59256161ddfbd1fa6c37e9aa5b31963de0173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b971c5f5fecbf62dc3c26b1ecb0d1356648971b4c0379d4df88358ee379ac9"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "z3"
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
