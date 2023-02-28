class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/a2/97/de1b98f3b226ca641e72bf1173d89ce9b383a10a60df5cddc0aa228ed2ea/jc-1.23.0.tar.gz"
  sha256 "b4133f7aabe2b461df5b643a4b618eefaa435c6b2b2ab88900399585465a70e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec7e6cb28b0dfb24bcc82e29bf446918170d6edfe09c11cc443228aafeb7ae5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7e6cb28b0dfb24bcc82e29bf446918170d6edfe09c11cc443228aafeb7ae5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec7e6cb28b0dfb24bcc82e29bf446918170d6edfe09c11cc443228aafeb7ae5e"
    sha256 cellar: :any_skip_relocation, ventura:        "0dbbf634cf051cc4d9c69bed5949e789e3d19b09cac5e32e174ab39a38f4dcf2"
    sha256 cellar: :any_skip_relocation, monterey:       "0dbbf634cf051cc4d9c69bed5949e789e3d19b09cac5e32e174ab39a38f4dcf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dbbf634cf051cc4d9c69bed5949e789e3d19b09cac5e32e174ab39a38f4dcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a4743e7595b66548039934d4f6982f2fd92ea9cd9855e5a1f5b681ff0b7159c"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
    generate_completions_from_executable(bin/"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
