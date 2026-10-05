class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "dee0c59e102abda6f5fe09cf0911860a53a9a2b3b061bc62b599cd81ff47b28c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "357641eadd1ece4935222480c36c8230ca4ce70f32ee55ae2909a3cae87b4a6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ac1868663e5c14aa96fde8da5e8d41bfa27b5d6612c35060e04936b7a3dfdb6"
    sha256 cellar: :any,                 arm64_sequoia:     "64012d1cb30d4c90d41c661b91ade305c0de5530157d8d9668b27c610e9b45b5"
    sha256 cellar: :any,                 arm64_linux:       "ffef0fa4777042b88a6896b7cc6d6bf962b821542d7aa339b39ceea80beffdfe"
    sha256 cellar: :any,                 x86_64_linux:      "99ea7233aa04535a3000101ee66426303824309f715c5cf1b8b67aedf14c5547"
  end

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  deny_network_access!

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
