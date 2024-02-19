class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/53/a6/065f0796a0a21bc040bc88c8a33410c12729a2a6f4c269d0349f685796da/jc-1.25.1.tar.gz"
  sha256 "683352e903ece9a86eae0c3232188e40178139e710c740a466ef91ed87c4cc7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c7f2950c9d3d31e9d626baa6ce2625c4b93843fc96d514e0e0d5bec58542d02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf89062abcc0c21452489d808c43bddc9c1de4347caf3985b1a83d397a131254"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64e0bbccc4e61310788f387bec958a2619b2ac52e6d8932b43d4686ad4cf690e"
    sha256 cellar: :any_skip_relocation, sonoma:         "691f3e055faa9f7d39c819c5dcb5918798d9de3a211f1c7cee95fac19b43e383"
    sha256 cellar: :any_skip_relocation, ventura:        "12a96110de8a97ccaf8b42d9c9891182168cc89c3ab56a970d8f5b63158806b2"
    sha256 cellar: :any_skip_relocation, monterey:       "3c1432745b1aab93453d9bd0f22e9e69c2febcb0534695067091aa0f3412a716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302125ccb03b4a86e285e1fe9548849be34eb7cda6d6f06972992ef517eb0e3d"
  end

  depends_on "pygments"
  depends_on "python@3.12"

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
