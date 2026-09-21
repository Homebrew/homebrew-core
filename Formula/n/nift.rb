class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "b7980c211ac5b15a0ccbfbce9e64d273ccb27104a0517c4ee6a0910f35f70343"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4574df51a5b47ad049179e649cfb7477eef43801b66e7e3c2fa449f0c33f60a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "143e3f93b75b033ea1bca8d57709afee38a5d19f56c6a8e4b73999a2359da26e"
    sha256 cellar: :any,                 arm64_sequoia:     "a745d839dca8ccaf9e1832c315fe27a5895c7938ab7741cc70f4c4a35638da72"
    sha256 cellar: :any,                 arm64_linux:       "ce8112e96be64ad065e6458851a734e5577701214ee5aa692f5c03f3bd1352df"
    sha256 cellar: :any,                 x86_64_linux:      "2ac92ac7295c3d260113cfd6905b30734e20cf0ee21f3c40e6b19813f68393de"
  end

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  def install
    if OS.mac? && MacOS.version <= :sequoia
      # Link LLVM's libc++ as the system one lacks floating-point `std::from_chars` before macOS 26
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
      inreplace "Makefile", /^CXXFLAGS \?= /, "\\0-D_LIBCPP_DISABLE_AVAILABILITY "
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
