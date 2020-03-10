class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/a6/93/38075713a7968a9e8484e894f604f99a68e443e0f9db0ed48063b1241969/eg-1.1.1.tar.gz"
  sha256 "3faa5fb453d8ba113975a1f31e37ace94867539ba9d46a40af4cea90028a04e4"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "a8453abcc4cc4cc2919b78e1649ac3640279d8f9fe0e44f9db083b3d3f4aa9f1" => :catalina
    sha256 "330a1d604b7889bedc72b8fb2d73a8c42ef1cea5234ade62a7db094debb6d9a1" => :mojave
    sha256 "d5f28b0a7c13377e6cc43ff4f13d2beadfea46b471bb2b52721d60e904d78189" => :high_sierra
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
