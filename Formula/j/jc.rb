class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/5b/82/146ef4c94297ef87c6a732c92dd57761bea2c2179e1b8ca8a6b9b8dd6ff7/jc-1.25.4.tar.gz"
  sha256 "a32eaf029c56b582dadae48895f20784d0f84f2fa28a8e2b32f377a8bffa8b39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab2ae0a9da71eb21e2b0a553ced8f03953a277f74bcb97ce58ca207ab752224"
    sha256 cellar: :any_skip_relocation, ventura:       "cab2ae0a9da71eb21e2b0a553ced8f03953a277f74bcb97ce58ca207ab752224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7a804ec72d181a9e05a1fcb095e633260203f0c3d6d30d57cc601f789064545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de81faab274ebbfa4289870a9ab9497059ec7a76af0e6f95ce5efc0ca3e9b8e"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/50/05/51dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958f/xmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
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
