class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/ed/6a/3ff582860b5d1f99b541ca3dac30a5bf2e146b79f8d0b1744bc0dc69b84f/plutoprint-0.13.1.tar.gz"
  sha256 "5834e527fae129ad7913410e20910eadb491c1f1b733447734c0dc7731a19ee8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81641c23c80f2e551e1ad513af7d7630f752a21621d063aaee29a78e8a57847f"
    sha256 cellar: :any,                 arm64_sequoia: "3ab79a9970f643fe516a9c58782c9c6841536fec8ad0021ee9c29a3101f05fb7"
    sha256 cellar: :any,                 arm64_sonoma:  "758e58def87a569d06bb522982b77b395f104152c5da036c6176a1256d44aedb"
    sha256 cellar: :any,                 sonoma:        "382eae3d1c1b7361140030ec6716e1dc89fc6376f309cd1506568081f6ac9138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593ce594c036c353b9524f74efa12431372d62bbc7c397d3cbedd798428f52ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb51315ac493a67e2c9fc49d50131f3c56d8db6b27cdf61e17a8a1ca3a8b9f52"
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
