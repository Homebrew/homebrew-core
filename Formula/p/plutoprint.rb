class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/c6/83/33aff545a0e96518e0c5f7315ab90ae14b55e672abf34630b79d14106048/plutoprint-0.7.0.tar.gz"
  sha256 "af09863568258188062b119bcb41917cc6a66bc95d1c6b1ec479eb319d6a698b"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "plutobook"
  depends_on "python@3.13"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500
  end

  on_ventura do
    depends_on "llvm"
  end

  on_linux do
    depends_on "python-setuptools"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  def install
    if OS.mac? && (MacOS.version == :ventura || DevelopmentTools.clang_build_version <= 1500)
      ENV.llvm_clang
      llvm = Formula["llvm"]
      ENV.append "LDFLAGS", "-L#{llvm.opt_lib}/c++ -L#{llvm.opt_lib}/unwind -lunwind"
      ENV.append "LDFLAGS", "-lc++"
      ENV.append "CXXFLAGS", "-stdlib=libc++"
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
