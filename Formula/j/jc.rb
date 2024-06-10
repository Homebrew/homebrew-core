class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/a5/82/bfb1ec7d9667bc2f922254bc62e12fd460a5de3b711518f5089df0a17180/jc-1.25.3.tar.gz"
  sha256 "fa3140ceda6cba1210d1362f363cd79a0514741e8a1dd6167db2b2e2d5f24f7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ca8454bc6cc7ac06a4fdd1d67b77abff7ca06355fd8d1c11c19076dcf1d0016"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06c333d6bd40e603f5473b761900ae66f46641e5645df74362e44dc50abad4be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad09d6f0172b49d46ed1cd163a7ed0c9cef6d772ce2be30c4a6dfa7adfae60d"
    sha256 cellar: :any_skip_relocation, sonoma:         "753ae34dfad5e91d4bfd77ff8f000410c6c4bfd356008fc5ab5f3716b8f5043a"
    sha256 cellar: :any_skip_relocation, ventura:        "47e488d2428ba555cb2db413e761313885a38694789f13c85747391b0fdda0cf"
    sha256 cellar: :any_skip_relocation, monterey:       "f6e288d6bf1b5aa59c061945d834e8432e357fac2b31860aedcc437b17ec6caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02aa9cb311522abbfde4ae0da22a11137ea102f174da9bed122c91690cebc451"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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
