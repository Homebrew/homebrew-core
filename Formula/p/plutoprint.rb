class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/16/e0/930e488122538d514698b65dcaf443f88ce9e66af0727d5ae6a1c7bb7223/plutoprint-0.21.0.tar.gz"
  sha256 "699c90f4d452b3e151184ca0ac707ddd04c29f29a8bb6f38a163559199e642bf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c020e8b05346eafc2d2905b664ff38d75a585165af0ce1308974ebd47755ea5c"
    sha256 cellar: :any, arm64_sequoia: "e8fe8280ec3e2f494540a437e6eadbc34b9e6e91872fc1ace0a33c49b94d032e"
    sha256 cellar: :any, arm64_sonoma:  "3ac065893c6d23a14a362e50a57957612eb4a26e31ea4e88ac7b50af56379493"
    sha256 cellar: :any, sonoma:        "7b82e4e950fce42ee1ddeaf574ff6855a49ddfb946d38f2cf8177b5411eaa38c"
    sha256 cellar: :any, arm64_linux:   "6e504a6172ad753a21e7fc414aa877c67c25e45f5c0f5932d59fbd44fce7259d"
    sha256 cellar: :any, x86_64_linux:  "0ed0d03c6871fff2a4e4c9a12232a0435e92229a7d833beea4415a7871c78632"
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
