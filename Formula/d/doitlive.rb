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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2daa5f32027ff7712740051dcb330a1c848b36e0334c02cedfcea3f4a137ef85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "946ce9358688fb5634500b7af4355a724f7862a8fb948d6a54ec1c0c10497ce1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301116d0a62a38271ae8c912c52685033f55ced59502dde85b37f93e35335e49"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9b79c717364cb83be9b5755758627c4e24bb3689aaa8280840d5d4c5e0fd3d3"
    sha256 cellar: :any_skip_relocation, ventura:        "be879e2d977218eb0e9fbab32439641da043c72c7ff51672950bb4907926e5dc"
    sha256 cellar: :any_skip_relocation, monterey:       "05ad943f30291839b9222947eb266559bc51be832071e62b8ccd7cf17b2ca248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f21feed234fdca264d7c8064df700bad1a6bbfcf37cfb1b9a59caf46f3a9ea"
  end

  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
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
