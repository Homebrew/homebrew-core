class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/c0/35/aca0b163ae7a201b8b9c27f1c5bc5020b0badc93c7019020288f2099ca21/plutoprint-0.9.0.tar.gz"
  sha256 "05c3c425dd57dbd5db0c26449e17e9e8cbc4eb041320697fa7c3f042dd3c1960"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47b20dcb6d4b4bcc9d631b923e716c115088437a564607dcc91c1cb8ea3d3d7d"
    sha256 cellar: :any,                 arm64_sonoma:  "8570fc375cdd7d4ec7ab531bb30a6ff4dcf69e3953ce8b658c21ea1b36629a41"
    sha256 cellar: :any,                 arm64_ventura: "d8f56880b26cd51abdd93fb423959eae3454d603f8fe000c41f411a2da2cbcbc"
    sha256 cellar: :any,                 sonoma:        "87ac3e7b0be2ddabf7f2fb18bae6d594eafc2f8e9b93adbf8b19946b45ff8213"
    sha256 cellar: :any,                 ventura:       "1b68863b5c31c3cba94561571b39dd571192c0cd0670d4d853fd220ad48b30bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b289becd2a56ae0d25a6cfe4f82e1d4f45af92a76a81be67b3999692e04d7d5b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.13"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm"
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
    if OS.mac? && (MacOS.version == :ventura || DevelopmentTools.clang_build_version <= 1499)
      ENV.llvm_clang
      llvm = Formula["llvm"]
      ENV.append "LDFLAGS", "-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib}/unwind -lunwind"
    end

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
