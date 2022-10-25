class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/30/77/e5f82206568c4729bd9a568d7cbd3112784fcb81a4500779aa8e83ddf6ba/jc-1.22.1.tar.gz"
  sha256 "57d6e5d6ded87b2fcc08be715a3aed326e930cb5c9d7abcc9e4d57fa8229189a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7d57e1c7bc367a8978982767166ff7118a052ee0c0b3988d5509f1a6000e3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7a9a683b2e59bff23f9fd558fe3999ecc871477ebd261c71d06bec952f869b8"
    sha256 cellar: :any_skip_relocation, monterey:       "9e80822eb640af5901825dff4eefeeb3d4d8980cb0683b3aa6357ed887171605"
    sha256 cellar: :any_skip_relocation, big_sur:        "e95ae5517dcbd3bbb881d5c4558c7d37c45a30e02cffc7e715eaf9b1da5cd042"
    sha256 cellar: :any_skip_relocation, catalina:       "6c268339c79ee8536945a1114cfc4571f72421b5c7f3259be7b1d6733768845e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125fe8f873b5b24c1bd645c6e1d9b45476b4a7b5465a286aa560f47ab61059ce"
  end

  depends_on "pygments"
  depends_on "python@3.10"

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
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
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
