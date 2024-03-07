class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/01/35/0e2dfffc90201f17436d3416f8d5c8b00e2187e410ec899bb62cf2cea59b/fypp-3.2.tar.gz"
  sha256 "05c20f71dd9a7206ffe2d8688032723f97b8c2984d472ba045819d7d2b513bce"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96ed097ad92dfefc28ccd5c4b31442da47a205a9c8cbab1d79a6a2bc17295893"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d9caddee587d281933e20dc009f96ab7ab04e856bde600dd0e92081f68e0ffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ae93051063f65a09473b0b447f68506731756ba2bff186985b972e1115f2352"
    sha256 cellar: :any_skip_relocation, sonoma:         "775084b42575716d4c0d52f1f8ee66e78a6d716f5f240724f2c73acafb6e0d30"
    sha256 cellar: :any_skip_relocation, ventura:        "bcbea4bd66d64e53f6362b45e6784399b80b569e08d431611988e5f2a97bb0e8"
    sha256 cellar: :any_skip_relocation, monterey:       "5ba31221724cc36d5eb1b23f125361e83b6d20d0de6db0ca328c276d9c0ed2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7ca5a9d4b1eb864aa5d7e0a5bdfc24afcae49900af8a4fde88b20630f89d6e3"
  end

  depends_on "gcc" => :test
  depends_on "python@3.12"

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
