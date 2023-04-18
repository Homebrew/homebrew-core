class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/82/09/110ed5ef1e1afb4e87e256b322f88bbfaa9fe59eb5f30d1764e0741c0735/yq-3.2.1.tar.gz"
  sha256 "e04dfc8670fcba5bba75e2a24940a544aa8c2789cd4c5171241a1275c8ab2f57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "700fae71fc3d172c7f656ed50276853c9a433fad6f41e4a4e858fe6153e3235c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4a253fa9231c9841b140df31665e2130ae7e8c1af5b6260310f04d64034d88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d928394bb7aa4b0ecde5301e5ee80b1e4f912eb06c527f5f8a9cd844e1b439ca"
    sha256 cellar: :any_skip_relocation, ventura:        "d3c65898cc1b61659dce60e701b104171f2deffba356bd5f4ed6c61d6f0a9bda"
    sha256 cellar: :any_skip_relocation, monterey:       "e54877743737d50eac9f282c395d73a6afc8f75ddf60e2077e70596ca9f9ee21"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6a2323d6d8309fd44dd1477d32a14e6cf55c9407a6226bc78a4f5e31cbb2775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc2123367005b9deea8cdbb48de38a5574dfc54c8c3be6a46620d886506668d8"
  end

  depends_on "jq"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/9d/50/e5b3e9824a387920c4b92870359c9f7dbf21a6cd6d3dff5bf4fd3b50237a/argcomplete-3.0.5.tar.gz"
    sha256 "fe3ce77125f434a0dd1bffe5f4643e64126d5731ce8d173d36f62fa43d6eb6f7"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
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
