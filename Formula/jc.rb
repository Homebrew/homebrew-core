class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/63/cf/302a0a5db3d376e88ded7dc2a9881da5e542e06b92dc7709735d87485ebd/jc-1.22.2.tar.gz"
  sha256 "2b72883f2d7e2e6678031bf5165754730057440cb0d5bcd7a134e6f29c0bb5b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524f5210c5ca18a3a3cb927cf57d0cdf17f5320893f41947e44c7c99a7e9f914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db3482631833103b5298007d319fd9e4bdc4a44be6a7d41c22ff3080cf38a6e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dc3c9d3d33351ccc8b1c76b48f1b27321b82e932d04753e1d5e8793328d45fd"
    sha256 cellar: :any_skip_relocation, monterey:       "406907895d69cd04286670ab80379b4502b06a65aa766ec46848b535e5ab2808"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4584bce417c745153a49959fe11d4d094e31f79b138d1613374eb794f7c97db"
    sha256 cellar: :any_skip_relocation, catalina:       "dfda389d667a6cac9ef7852db44ecfd5c14b89d1e2afcdc27d16196bae7ae36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca68a115eced429472ccf8ed316908afd8bb9853cddacf26609e4a08869250b5"
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
