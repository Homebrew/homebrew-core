class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/f1/11/79902a32afed6e1ccd8db0f937ff6027fcdb1118602013910fc1fed9b50f/jc-1.22.4.tar.gz"
  sha256 "4088d599834eea242538dbd4011d3efd8fa0d2a43887d6813a904309f040bdaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ddca1cc7f3e71a83842d41c47cd013dafcb6149bcbabe91e7503696805e3c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ddca1cc7f3e71a83842d41c47cd013dafcb6149bcbabe91e7503696805e3c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34ddca1cc7f3e71a83842d41c47cd013dafcb6149bcbabe91e7503696805e3c1"
    sha256 cellar: :any_skip_relocation, ventura:        "3b8df9f45ac264e392e055380294307a78770fff305f373f3cfb011c6cfb6577"
    sha256 cellar: :any_skip_relocation, monterey:       "3b8df9f45ac264e392e055380294307a78770fff305f373f3cfb011c6cfb6577"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b8df9f45ac264e392e055380294307a78770fff305f373f3cfb011c6cfb6577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7b71308bbc804ae50e928ffa38b32ea7f2287810264b959bdda5dea99dddd78"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
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
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
