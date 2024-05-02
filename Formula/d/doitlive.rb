class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/32/75/c94e4d4e7fac8606e199fad35a00b33e4252d00078f25285f91e97e546c0/doitlive-5.1.0.tar.gz"
  sha256 "b6bcd25f9f037b7e96e34d68549306adb3e8c83f6e92c51ec2b225abc05b25c5"
  license "MIT"
  head "https://github.com/sloria/doitlive.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7f3203d43405983df8f0a5485f13c31231568333b2da35a9b2cfeff8f55c32e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "284dc2184e111fccb4d8f57b8e181659cdd7a3dda2404f94a60ad46f324339fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c52956766e5b2351402959a4a6ad901cb0ddc652446db97e84671604f1f6e09"
    sha256 cellar: :any_skip_relocation, sonoma:         "8de40bb4d2936e765e4a91030a4fd720c988562da2736555a6212390611457b6"
    sha256 cellar: :any_skip_relocation, ventura:        "1d895dee3252e9c18e0827cd8220c2d42d403b47d567fe95fa016b530e554917"
    sha256 cellar: :any_skip_relocation, monterey:       "37b3f7099735ddbf60c94372b40e065f2bd62b3f56d89711514d7724639c7260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ebbdb6f7c62955f7d9b2f8e130bf6e033fd989b1b9c48c50c8fe2cfd1b29d8"
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
    url "https://files.pythonhosted.org/packages/2f/a7/822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34f/click-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
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
