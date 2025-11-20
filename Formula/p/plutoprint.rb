class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/77/7f/50144b12fceab37b5d5273d52466c31d27da49ca272b03ff3e20e98d3d00/plutoprint-0.13.0.tar.gz"
  sha256 "02ec801a7cdee89085d050b274ad9c3366949c085909149a563d1acf383a57aa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db46a3058b9fa23f849cf90156a333a56f011d26349cf5c39ce8b920ee50c27f"
    sha256 cellar: :any,                 arm64_sequoia: "c5941fa838a5b858eec2a3fc6ad91f2810b61946d74ab6191b5e5c68bec32008"
    sha256 cellar: :any,                 arm64_sonoma:  "adece8ea2c09d22ae8fa3004d240ca17636a88339b96269987b4ee222040c576"
    sha256 cellar: :any,                 sonoma:        "aa22f2e433962d5fcfcd9d01b0a2c7d41b3df3c99e5035864622fbd3645aa758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8325d7bbb27c57930a2fa71d43c3e24f8d83ed70b803333dc3be9d1d92e603f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb11b29eb9c0852cd954d91d1030f1b398f3c471500f709354ade58091371923"
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
