class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://github.com/aradi/fypp/archive/refs/tags/3.1.tar.gz"
  sha256 "0f66e849869632978a8a0623ee510bb860a74004fdabfbfb542656c6c1a7eb5a"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ca9fbd711044d3b965ccdd93d62b2436d711e56007444ccc60e37be7357da85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ca9fbd711044d3b965ccdd93d62b2436d711e56007444ccc60e37be7357da85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ca9fbd711044d3b965ccdd93d62b2436d711e56007444ccc60e37be7357da85"
    sha256 cellar: :any_skip_relocation, ventura:        "8372e31d3e4eeac3f809238c738cf05024367264f1fe41fbcb4ed238856b5448"
    sha256 cellar: :any_skip_relocation, monterey:       "8372e31d3e4eeac3f809238c738cf05024367264f1fe41fbcb4ed238856b5448"
    sha256 cellar: :any_skip_relocation, big_sur:        "8372e31d3e4eeac3f809238c738cf05024367264f1fe41fbcb4ed238856b5448"
    sha256 cellar: :any_skip_relocation, catalina:       "8372e31d3e4eeac3f809238c738cf05024367264f1fe41fbcb4ed238856b5448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb267affdd4b9177495d506ea7e5c53c51bb8c1314edef2f7b3cfaed856ea704"
  end

  depends_on "gcc" => :test
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"fypp", "--version"
    (testpath/"hello.F90").write <<~EOS
      program hello
      #:for val in [_SYSTEM_, _MACHINE_, _FILE_, _LINE_]
        print *, '${val}$'
      #:endfor
      end
    EOS
    system bin/"fypp", testpath/"hello.F90", testpath/"hello.f90"
    ENV.fortran
    system ENV.fc, testpath/"hello.f90", "-o", testpath/"hello"
    system testpath/"hello"
  end
end
