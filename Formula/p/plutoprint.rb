class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/2a/62/3cc668263c427e91353ede5de966681bc9cca695a7031542e03f8d4b41a4/plutoprint-0.5.0.tar.gz"
  sha256 "cb35a9fb4088f356e1ae82a0e3c84d1fb420c1a3d314f61c1086eed37ef9d63d"
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
