class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/63/cf/302a0a5db3d376e88ded7dc2a9881da5e542e06b92dc7709735d87485ebd/jc-1.22.2.tar.gz"
  sha256 "2b72883f2d7e2e6678031bf5165754730057440cb0d5bcd7a134e6f29c0bb5b4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11ec67355daebadd14e7a17c9b825530a02e7d6136d3a9131e4c45bf4fcb82b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ec67355daebadd14e7a17c9b825530a02e7d6136d3a9131e4c45bf4fcb82b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ec67355daebadd14e7a17c9b825530a02e7d6136d3a9131e4c45bf4fcb82b1"
    sha256 cellar: :any_skip_relocation, ventura:        "e7e2201b4e374cd30ee8be9d6ed94ac508064ae5056f43d767125e2bef7da1ac"
    sha256 cellar: :any_skip_relocation, monterey:       "e7e2201b4e374cd30ee8be9d6ed94ac508064ae5056f43d767125e2bef7da1ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7e2201b4e374cd30ee8be9d6ed94ac508064ae5056f43d767125e2bef7da1ac"
    sha256 cellar: :any_skip_relocation, catalina:       "e7e2201b4e374cd30ee8be9d6ed94ac508064ae5056f43d767125e2bef7da1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ae227d31a88b7eb294f66345f26ada0bc8c958340941ab1a288516acdba134"
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
