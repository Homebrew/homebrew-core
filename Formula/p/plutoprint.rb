class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/cc/6c/43d05d5267af366181586269c81af50ca70ed076d19115914b23cdf12dde/plutoprint-0.24.0.tar.gz"
  sha256 "48f077f16684415debae3bcd0af79d7d0405ff1dd16833d86ddce5f93dce3131"
  license "MIT"

  bottle do
    manifest_sha256 "219f50019646f0515528e08814053b5fa0d7840015fff3264775f0a50c5e5019"
    sha256 cellar: :any, arm64_golden_gate: "864bcb83c5dff189b34323d442da7f1eb7f5808332137856007b18f96bb92154"
    sha256 cellar: :any, arm64_tahoe:       "084943c22f7ce828d8d6d578ae0a89efe83bbfcc51481ccbcf7dc99cfef02189"
    sha256 cellar: :any, arm64_sequoia:     "750aaffe1b3aa1a1aa17b8d7ffdc142897559f202c3a749ed635548d79d6b1c2"
    sha256 cellar: :any, arm64_linux:       "9db85dfe17843b626ee53142f2fc318393cfe8927c69f32236fd8b1acd96e6da"
    sha256 cellar: :any, x86_64_linux:      "26ad7e94ad5244f9fdce4dd3f85c62e7775e5f168bfe9ba6713ebf4dd1b3c58d"
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
