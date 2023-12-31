class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/51/6d/bf23bc6d7fe17f0b219730e68f03075a0f046010cf2f8b7b5e36a2709696/jc-1.24.0.tar.gz"
  sha256 "13af052923db3eabd3a8118048763f852c7be9773e81f00035e18402726de05b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdc1946dc57965cf6f56c41516345748b9c833f55c764fc8750d5688dadd8929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f50b376ad0d740968a9676ce261e8965b380e49ca9247f8a312a9d10e253cf90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8654727eccb7890f89494825db658fe9e4c30ae8892fd20bec95bd76667164d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b65077efc8426653a7076d35a1c9f77841822e9943837046abcedc4f99c98c6"
    sha256 cellar: :any_skip_relocation, ventura:        "81dae03d13808ac6c17e6b637a5c9616392b75d32d7027c6b0bda9b4a8f6a327"
    sha256 cellar: :any_skip_relocation, monterey:       "3b4e55070652b7f1144aa7a4050bab086bee8e22a0b33024e7db2bf2758f78a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93a27953f583e251a49355d12bb02b5fa5413c6bdd8bc705c358fc060b3c6ad"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
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
