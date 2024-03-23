class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/39/2e/c0d557b2ee673e2e0aef24a01e732aa232f6b1e180f339058f674f391ab8/jc-1.25.2.tar.gz"
  sha256 "97ada193495f79550f06fe0cbfb119ff470bcca57c1cc593a5cdb0008720e0b3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55c903705ce67ff93f43f85dbc7c32d2850e38b11dd717a62ea8ce6111938d6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f3fb4606cb3aba99be0a698eb852c092708e8a770e6753fc6e35dc18c40cb4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f4d483597e0252230b5975f0405939f07ce61c19e4d934f25ee03fc6da80413"
    sha256 cellar: :any_skip_relocation, sonoma:         "11f6229647fbb0da8645e53ecc9a4020cbb57bce03904e4f803098fe4ad6ef6d"
    sha256 cellar: :any_skip_relocation, ventura:        "75abfec3c65a98081bd3a5d3e96fcae1ae189e9aef727228df172c0cf1b05549"
    sha256 cellar: :any_skip_relocation, monterey:       "442c02f10c0c91f6855cc29ec47692e6f116905794649666c8c5eaa20469bf7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5afebfa1c9f5c96d8c27c27fc5c3301ccd09442f640a7ae4f0317ed33cc3aed"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/29/81/4dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9/ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
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
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https://sourceforge.net/p/ruamel-yaml-clib/tickets/32/
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

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
