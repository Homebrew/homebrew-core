class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/cf/53/156600a9b55da259e419025fa8d08e7253b64e6af5923d53bf3bb6f41ca4/plutoprint-0.19.0.tar.gz"
  sha256 "55f3c6724f0dc217d28218ced1aacc23f7f87bf2b7e6682152eb9f80eb4e3d3c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5644b09767a77c99368716526731fb9b4587493673e79e18573702db2a213265"
    sha256 cellar: :any,                 arm64_sequoia: "b62f892310c5301a7259f2af4545b7adfd97073e45ace8941f69bcf8aa4bd759"
    sha256 cellar: :any,                 arm64_sonoma:  "674441d36e2d4a753897e2eaa1abda85a9dde6304d25171e68d3cfb92b4bc4b1"
    sha256 cellar: :any,                 sonoma:        "3c66c86c66a82405bde22f2863daf0ff9d7555cd99f7e559c027519993724ebe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fe7b6bc2cd169d34d2069a6c24e79e56772ba943a55d55920be61e912b14285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b9bfe994d3212b86cce0c92888087e7329703f40432aaa49fb809f44c47f43"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def python3
    "python3.14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plutoprint --version")

    (testpath/"test.html").write <<~HTML
      <h1>Hello World!</h1>
    HTML

    system bin/"plutoprint", "test.html", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
