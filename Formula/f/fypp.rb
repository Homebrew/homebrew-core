class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/01/35/0e2dfffc90201f17436d3416f8d5c8b00e2187e410ec899bb62cf2cea59b/fypp-3.2.tar.gz"
  sha256 "05c20f71dd9a7206ffe2d8688032723f97b8c2984d472ba045819d7d2b513bce"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cd94740ce7a46a8d83fb85b7a547c1f20293ddbffd0cbeabb5ea004ce35c6c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6da6adc8cb18355e092f51ba9678fb04a2c42343aad56fde8deda98486dbd9b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4838aabafed4b766490c05ecf385254451e339047708f576ab220d44510b5c1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8096ae3dd329d012469ca788d0c09a54915fe7207c31d745d5179832935d6f69"
    sha256 cellar: :any_skip_relocation, ventura:        "ed430c4458f4bc7d4861f582276a2595f60e4814c47e6a995ba742cb1e8a9196"
    sha256 cellar: :any_skip_relocation, monterey:       "9f9c8c7f3b97fee56dc5a45bc75b1c722e2dac1f5bfca1b97b7160ea86e84f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2b773c9ffd79f4f5adec76d7a01eae787f7e175de659e44e865628042690f9"
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
