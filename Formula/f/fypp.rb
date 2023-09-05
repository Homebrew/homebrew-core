class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://github.com/aradi/fypp/archive/refs/tags/3.2.tar.gz"
  sha256 "33f48c8d2337db539865265ce33c7c50e4d521aacbd31ac7b7e8b189d771ce1d"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a72f87c255aefd9dfc94a8acf0054e9d00b009ca29c378c55a948a267ccadb80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eaaeb839757540bf468a3c4a34edfae25ebce99847fd5ef3f88ff748b2df440"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ba5ec09160516d21d7afde092b4b78fb95144b2b4fd29d2013f52b0b47ed247"
    sha256 cellar: :any_skip_relocation, ventura:        "97f13cd046501c26e14d8e6ddd26917d864776426468fce6441cfdd62781a00a"
    sha256 cellar: :any_skip_relocation, monterey:       "7d92b29bd552bd7dcbb5c8aa19f0482aa1f0d3661191c8cc419f378c97b76a0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "af80edb6449af0192ce8586f0f07af91aedb55d52ad352207e04ac25820656f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "676b067d2f477d15bceabf21d7dec716c76d3c438e20384635ecfcaf506254d3"
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
