class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/83/d7/c15fb7d9d017f09777ee8b70c04091a490e56c3b289c6a23706d62942a8b/plutoprint-0.22.0.tar.gz"
  sha256 "3660300fe57880782f2488fddbdab19bf3e7fde6d6713a696c0c2869006dca10"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e2ecb09853cca5871a3155f1aaf4e671056406cb2c8e82b7bb1f5e8e955e2edd"
    sha256 cellar: :any, arm64_sequoia: "c0861aaff3314e4f582c9c9f1d336192687f9940a8f585aed805f8e3235e5f29"
    sha256 cellar: :any, arm64_sonoma:  "23bc222b6d595141275b06daaaa9316ad4286fbb51b8a3e87b79de1c83ba83b0"
    sha256 cellar: :any, sonoma:        "354961b86c149d14067adb33f66d2dfb82b193ffc9f6aae121550cd254479bfd"
    sha256 cellar: :any, arm64_linux:   "bc6c8cc94ed6eba3643710acbcf706d5f86e4892d58fe8bfbc6ce9653bc42c9d"
    sha256 cellar: :any, x86_64_linux:  "8c9c418561440854f2f8d1c6690884041b310ed5244a704f57c177297486af85"
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
