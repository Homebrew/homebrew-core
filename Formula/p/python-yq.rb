class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/fb/28/293f7e1416a840863ee976897ea38dd6524e67872429bbf10e9428fd22a6/yq-3.3.1.tar.gz"
  sha256 "09c6c56bae8d5a3fe36222aa74fd343625071c511f02699c35346388a47a32a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0ecc3dbdd5031a40c567266438843224e4fe8a1bb173e40dbdee08b6fed2633b"
    sha256 cellar: :any,                 arm64_ventura:  "a3b2e22c6978bf8a606b45d378496ccf587c617686e64457e997fe7ff8797be5"
    sha256 cellar: :any,                 arm64_monterey: "dfa185947b5609144059a9e488876a3d22f3903a24aa4ba2dcdc0fd49121c057"
    sha256 cellar: :any,                 sonoma:         "dbf8e04f1e572d04ca513e22711e54cc9ac6078e2b096fb0932d77dd67fefec8"
    sha256 cellar: :any,                 ventura:        "e5f609838c876e73c184b073a365a193b0052b0116d1e48a0a887b96ea5a4ded"
    sha256 cellar: :any,                 monterey:       "053625b072aecc7967687f58e4e7eacb9d0597037668444c9812183d9d7b2347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51fbfd4335f9f59476a69e062f029506d21d2c3146735d44f2bacb0a97bf100d"
  end

  depends_on "jq"
  depends_on "libyaml"
  depends_on "python@3.12"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/7d/49/4c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797/tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
