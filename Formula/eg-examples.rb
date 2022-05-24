class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/8b/b7/88e0333b9a3633ec686246b5f1c1ee4cad27246ab5206b511fd5127e506f/eg-1.2.1.tar.gz"
  sha256 "e3608ec0b05fffa0faec0b01baeb85c128e0b3c836477063ee507077a2b2dc0c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d089071964aeefc2ca28062eff414a0c0dea3d940495212c71a2609e4749b36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d089071964aeefc2ca28062eff414a0c0dea3d940495212c71a2609e4749b36"
    sha256 cellar: :any_skip_relocation, monterey:       "9e766b57ef1ede0a5cd68da245d372573860545702af673ba18693159cc95657"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e766b57ef1ede0a5cd68da245d372573860545702af673ba18693159cc95657"
    sha256 cellar: :any_skip_relocation, catalina:       "9e766b57ef1ede0a5cd68da245d372573860545702af673ba18693159cc95657"
    sha256 cellar: :any_skip_relocation, mojave:         "9e766b57ef1ede0a5cd68da245d372573860545702af673ba18693159cc95657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d057caedc12f52baeaec1c47fa9b6f3346d9d7c4e8e519ca5781f1915e6f9bc"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
