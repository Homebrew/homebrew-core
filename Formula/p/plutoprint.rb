class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/24/9d/c611a24fb16258437f2b2908e10011f8cb975a992ef20a3cb0d98a250dc8/plutoprint-0.11.0.tar.gz"
  sha256 "f6290e0c473bdc810cb5457503157f90a7c0f9399b8fa3147cea7fed93455395"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38d3cb7186e53f2d6523450d8e5000caa48a7a820b515c4c2c776d2ab01393a7"
    sha256 cellar: :any,                 arm64_sequoia: "1c944d91e5274b8947e9615911fdc4cf00975c2cc79dce1e7b5352eb7b4f69d8"
    sha256 cellar: :any,                 arm64_sonoma:  "ba5f89031841b022d10c8ec35497409feef3364092d4443300a1fb1897adc743"
    sha256 cellar: :any,                 sonoma:        "e5c567cd6b6127367edacaa1da71ff9cb4aa0315ca732227fa88829089604963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f721b1e3a495dcd6b555a28eb325649ad01b0893ccc182ea130f7b168a108ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "376fe416477e9b7d7f72800697dd9870d90172dc3030a744b44834622707f06e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.13"

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
    "python3.13"
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
