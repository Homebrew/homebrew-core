class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/a5/82/bfb1ec7d9667bc2f922254bc62e12fd460a5de3b711518f5089df0a17180/jc-1.25.3.tar.gz"
  sha256 "fa3140ceda6cba1210d1362f363cd79a0514741e8a1dd6167db2b2e2d5f24f7b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bcd8287e3d93d1b538b33368b87c69b11a089aa0188d6e8cd7d0b8680d612df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bcd8287e3d93d1b538b33368b87c69b11a089aa0188d6e8cd7d0b8680d612df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bcd8287e3d93d1b538b33368b87c69b11a089aa0188d6e8cd7d0b8680d612df"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a3db1b3dacc4d23c1c4a3db8894d2203aaa7de2ca69bd579bfe906205b7876"
    sha256 cellar: :any_skip_relocation, ventura:       "e4a3db1b3dacc4d23c1c4a3db8894d2203aaa7de2ca69bd579bfe906205b7876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bcd8287e3d93d1b538b33368b87c69b11a089aa0188d6e8cd7d0b8680d612df"
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
    url "https://files.pythonhosted.org/packages/98/f7/d29b8cdc9d8d075673be0f800013c1161e2fd4234546a140855a1bcc9eb4/xmltodict-0.14.1.tar.gz"
    sha256 "338c8431e4fc554517651972d62f06958718f6262b04316917008e8fd677a6b0"
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
