class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/67/4f/092f0393f4d9ef95d4601586ee9775a2b8a27993cbec62c010518df968d1/jc-1.23.1.tar.gz"
  sha256 "a0f3d7bb2f25a186bc80606927b33e55dd0c1fe2ebc3ad4d58b149b7e299b4ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a36568d697b5b9ab56d0a4d73515f6b32f02462375187d9f257185608be4bc0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36568d697b5b9ab56d0a4d73515f6b32f02462375187d9f257185608be4bc0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a36568d697b5b9ab56d0a4d73515f6b32f02462375187d9f257185608be4bc0c"
    sha256 cellar: :any_skip_relocation, ventura:        "902a2b14c45903ff8cc225e6d25d1e6258f1f584d4d2de859df3a76d305a26c8"
    sha256 cellar: :any_skip_relocation, monterey:       "902a2b14c45903ff8cc225e6d25d1e6258f1f584d4d2de859df3a76d305a26c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "902a2b14c45903ff8cc225e6d25d1e6258f1f584d4d2de859df3a76d305a26c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0fc14269a938757cbef7681e032711f2ea8aade7f80c7db8eea5a2f36480287"
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
