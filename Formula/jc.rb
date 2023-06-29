class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/d3/a6/b21f4785ee03d84597dbeeec8bffc6869d2040a47a3864c68ed498a5acab/jc-1.23.3.tar.gz"
  sha256 "e91097121b8f5a553dbb948d1fcc46d220d9b62236d73016eb0d8dad3cd9dc36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c49ca333d54b89e433571f3d4510a6a6c5fd776d3243e1139093faf2b00c2ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab7f870dda5a28fc79077bd4d0fc0431b25c5e7885fb81fef174086dde1c39ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90b48797a2499c7de46d7c65b595a5fc6c848b46561ddcdd771e4750a18c2971"
    sha256 cellar: :any_skip_relocation, ventura:        "29e5e9c8bcd1ba56145ad5f790038a23937e65e5b102e138bcb49db7570354f8"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c2e1a45e49afa2e4c197a935d655cc557a4da09b11945d7ae56ffcdfc2960e"
    sha256 cellar: :any_skip_relocation, big_sur:        "585042d7de0f9cf22f5e87f45a041df4b36da08f0e404fc39965669312bec1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b93e8269b78ea7af43245bbb93e2e6e27fefc0c5728ac5f01c3c52d5ae79f9"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
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
