class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/59/06/7281154a4cd961f56302d9cac300cc8fc965b16d04ce797ed622a2f53586/eg-1.2.0.tar.gz"
  sha256 "ac9827824c2c9aee0fd0a54ca57440021a0a87868b503b215c2c273a035bef59"

  bottle do
    cellar :any_skip_relocation
    sha256 "46a9ac200202e3701ced8127521ef3d717675d8460453b4c4280990381e4f4b7" => :catalina
    sha256 "882c95a2e4ff16639e596869fab1459acc2b40326ad85d1a2e22352933522cb7" => :mojave
    sha256 "1e806034a1d7ec1f50654e33e71e72670237ffa33358c7e7490af5d703ec4d62" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
