class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/46/56/56cdf93d1633cba2b16486aa27978893ab3791dae51b27068e09d08bd300/ptpython-3.0.26.tar.gz"
  sha256 "c8fb1406502dc349d99c57eaf06e7116f3b2deac94f02f342bae68708909f743"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbc5cd523b19762f085171802f99fe8e02dd5ef4fd33bfd2ef904610328fa705"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf45fd30c6f0315cc6d5e080bb55facb73c9d77944a256e3667db8ad16201942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e683af5524123d28e30f19b8aa9b33648d91486377514a62588cbbe516cfb91"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b587bb8ddb56b207e002953df90011a39c5b96ab224e0b278521090773aeec3"
    sha256 cellar: :any_skip_relocation, ventura:        "62ede092c68ab613f7165a707f573f980d0b1cc36a65171a08a79b3ba49017e9"
    sha256 cellar: :any_skip_relocation, monterey:       "d67fc517edfe6e721cdbab1f84684000ba7dc8459b001187ff5ec6dee2cf6d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfef990ecc1a86c0e0bfca31eb5192e04d66c216d153a7cabdef2b6012a7e889"
  end

  depends_on "python@3.12"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
