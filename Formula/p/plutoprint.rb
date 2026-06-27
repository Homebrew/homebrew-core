class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/27/2b/a9c50995cb828efacfe31cb0b3c8bac793ece51c87afa794a88fe7667084/plutoprint-0.20.0.tar.gz"
  sha256 "1df8118b07f1d20cd8265174beef50430cfbb853ee0de7abdae2c8fe5e256b9d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3ff7bb3f7361d0bfbe5129e77da16ed7c458349b7556ee3b241e334d5bed854"
    sha256 cellar: :any,                 arm64_sequoia: "1fd7c17a7a6e50acad7112ed4e1520cc52009ff660998f123e64d3c486a535a2"
    sha256 cellar: :any,                 arm64_sonoma:  "0c3aff69e4463dc942ea64761450d2c9b17f9635254c9d6f3876e0e6a8b80f27"
    sha256 cellar: :any,                 sonoma:        "cbca8d0da2be70b5c984a813b207e47393d59b8108dc5ed03333eb8fc314aee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42e7c2c307c79a96dd8f1c08e77254b049f7a3fc66aac8091d41fb22d8f87984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615085b11051cd2b5b9e648eb24757f666a4ec414990aaf8818597c9f9ad3885"
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
