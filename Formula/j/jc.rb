class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/c0/06/62f18df8f03b042eea35749dc957e26d6b43f9aba3eb932c126a6aeb92af/jc-1.23.4.tar.gz"
  sha256 "c1e86e230cd3f890953868b3016e45dd3806b8f467e24954335d433644db4df8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9affdf8f68cb3847c1e8f697b55f948af4e7a16ba98f205a499d9aaef1d55bb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739a800899daba0ca0648e277645741b7c415cd0872eddc70a5e1cf73dfc62b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4bd61dd4c0973077240a0cc49c4d5669775a0b75b0c57ac7a74934da840c9d8"
    sha256 cellar: :any_skip_relocation, ventura:        "9bf4fa079ff11c6a831658d56ec3319653023d9dfbf7418138c05eef983ee1a9"
    sha256 cellar: :any_skip_relocation, monterey:       "d718612145c8b7106e6a9601ef79531eed0436dd3a4d0b4a938c59a9ea1a3c0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "106827661e1493e33a430cc3ff19a12a5a8db1009e4bba8645ea0f2a39fb5d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44dcb7108c3a4b2e7acc24c4475b5dddc262824890a3fce5c3ae764d539f9287"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
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
    generate_completions_from_executable(bin/"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n",
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
