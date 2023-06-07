class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/01/19/473df85a39986476cd3d10c478a3f5ed65dc949b3bf4e1982f68085c48e2/jc-1.23.2.tar.gz"
  sha256 "a784745fa378ca76c6d44e752d30a628ea26ea18240e72a171f01b6895076266"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c521587cf38b4d11e7efc7b1a283554ad4366f5861fd04d8c7dd364ad53e1e41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c521587cf38b4d11e7efc7b1a283554ad4366f5861fd04d8c7dd364ad53e1e41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c521587cf38b4d11e7efc7b1a283554ad4366f5861fd04d8c7dd364ad53e1e41"
    sha256 cellar: :any_skip_relocation, ventura:        "46b4c35de5a0e7d05b709d9d1c7bb9f23d58442bef4a319ff0f1c1473dad6028"
    sha256 cellar: :any_skip_relocation, monterey:       "46b4c35de5a0e7d05b709d9d1c7bb9f23d58442bef4a319ff0f1c1473dad6028"
    sha256 cellar: :any_skip_relocation, big_sur:        "46b4c35de5a0e7d05b709d9d1c7bb9f23d58442bef4a319ff0f1c1473dad6028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9f74da170d35fe7c0daa869cf00a01670dc5ce6800c073498f11dbe3b9a1f1"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "ruamel-yaml" do
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
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n",
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
