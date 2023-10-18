class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/c0/06/62f18df8f03b042eea35749dc957e26d6b43f9aba3eb932c126a6aeb92af/jc-1.23.4.tar.gz"
  sha256 "c1e86e230cd3f890953868b3016e45dd3806b8f467e24954335d433644db4df8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37233b0b2000cba1832c7f57b4d3e822137c4d99b728558efcb5fab413267dcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f60ba35ce1b3ea71683ce71610a2f7c857bb1488e019364e4b313aa3b9b4ce3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ecdba2eec1b9396f736002ee88366498cb01ea688ffc9dfa69621278470c8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e07c53b1e47ac1330df052b205ae96b5c835839a00d1feed4d59f4849e32de10"
    sha256 cellar: :any_skip_relocation, ventura:        "f231766d63ce0a64e37fa6a8e68f49b6febfcaf07acd5c3476a4bc34b43c189b"
    sha256 cellar: :any_skip_relocation, monterey:       "8b17f4fdea74d7df21a11644b46efdeefccba98fcccee80f44f78db35d16432a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cef8094611b16c79aca23937889a2409726e95f90e638aaed3c301e15b76f7"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/de/7d/4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54/ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
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
