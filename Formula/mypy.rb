class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/0e/5c/fbe112ca73d4c6a9e65336f48099c60800514d8949b4129c093a84a28dc8/mypy-0.991.tar.gz"
  sha256 "3c0165ba8f354a6d9881809ef29f1a9318a236a6d81c690094c5df32107bde06"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "895f00e65b177c34d4b4bcacb81c8d7f44ab9f9a9df88566a8f417b3c998b934"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22ff690ce4f975ad294d7955323da8fbe809b6281851bd157b9620839ed8bbbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4047975ce033bf2bda81b888ed622a7cf3d936240731df891a0a746dd57b316a"
    sha256 cellar: :any_skip_relocation, ventura:        "864a08160980218aeac27ce109f9225cd3135a77f60c6eb3c44af4a13aed3ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "02f44a88333b0a6f09eedc9c653b7d547db18e0256b0fab3e7ab0b44853d716a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5e8e1a568aa9ce995fd07dcd11320dd9eae8b254c6c67a91615691b3539c9c4"
    sha256 cellar: :any_skip_relocation, catalina:       "582e4f03123861d5d3831353452f440b96f169a45c44f221d64b96b078884661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a38066ed71085b2af0027ce142024c02d06bc57ac2631dd06c57913ae5d8f7fe"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
    sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
