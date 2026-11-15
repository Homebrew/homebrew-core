class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/6b/e8/7db9d2d4801b80928f3b53d90d7343873aebed06b4cef5b71bc25f77086b/plutoprint-0.23.0.tar.gz"
  sha256 "6240e645599f08953fe0296b5b1955c6a978b212a05b878c2ba652a8ce7a0c82"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2fc677d516e4b586088b75993a9ee6d32f7d0f56efefa57426073a25aece62a9"
    sha256 cellar: :any, arm64_tahoe:       "825dedda3c8003a5eef781799708145d4a8a2d223c6ec6ebb8513f96048e3b93"
    sha256 cellar: :any, arm64_sequoia:     "95a0b4eb6dfc23fec8abe851647c613eb1c00a4e83e82cc2794c473a5cac3525"
    sha256 cellar: :any, arm64_linux:       "c2ca8aee077ab93bab9c236b369b2f1ba189243571174c291f8fb895fb2c6b73"
    sha256 cellar: :any, x86_64_linux:      "25c72232fadaf5a333794697c40d2c64a69872ec50a530f96d3defac70d2e6c0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.15"

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
