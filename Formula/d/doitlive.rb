class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/32/75/c94e4d4e7fac8606e199fad35a00b33e4252d00078f25285f91e97e546c0/doitlive-5.1.0.tar.gz"
  sha256 "b6bcd25f9f037b7e96e34d68549306adb3e8c83f6e92c51ec2b225abc05b25c5"
  license "MIT"
  revision 1
  head "https://github.com/sloria/doitlive.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae18d34cf330aefd1bec32fdb07945a4c4ec3cce331426d34265dc758c34f35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9991e43a40f485d6b810ddd53856c70186ebd585800a8785a512b60ad2120ed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f88c1cbef31bd6f30e2b27313a371994468f78ac39b4dd32a8b073414b863ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b1a404053a75c01c185829be0fd585f16508a8abad3da9b0c48499e8a54d1c"
    sha256 cellar: :any_skip_relocation, ventura:       "25c0574a853f230864811bdc57cc9d3ed0ec72619056d4ad76c890cd5dce45b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc26ad664b446225fcc8ab45387172aab3067f0d76814b404f7a9d46dbbfe069"
  end

  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin/"doitlive", "themes", "--preview"
  end
end
