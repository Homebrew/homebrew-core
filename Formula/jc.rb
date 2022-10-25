class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/30/77/e5f82206568c4729bd9a568d7cbd3112784fcb81a4500779aa8e83ddf6ba/jc-1.22.1.tar.gz"
  sha256 "57d6e5d6ded87b2fcc08be715a3aed326e930cb5c9d7abcc9e4d57fa8229189a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d55a4b1b9afc68a2cbfbab1af4eef4a25f4e772b3f8dbc573e829313e62e5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bba3810ad2ddf022f6c103e56293f5e2c976ce05d4c34c7baf2e481643dfb8f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17f0010b5f064a7a73d411f2a0f7280f31c5c97060893241a8c845d65642720b"
    sha256 cellar: :any_skip_relocation, monterey:       "f76ed9da3cc0143ac1231cb92716c436d6ac604e0c5e90b0a6c4571ac66805a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9c8ff7aaeef8db0bf74ded4c10ebea571caec56f15f19000d0168d6bf2be7a5"
    sha256 cellar: :any_skip_relocation, catalina:       "47837d955f36346f734184e590e43a87e861ebcc45f525c7a9dd53c6f4cc321c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38faf7a8331325f89bba621e728abec5da15e132f93ff2c45c691cc03a5f51fb"
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
