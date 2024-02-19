class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/32/75/c94e4d4e7fac8606e199fad35a00b33e4252d00078f25285f91e97e546c0/doitlive-5.1.0.tar.gz"
  sha256 "b6bcd25f9f037b7e96e34d68549306adb3e8c83f6e92c51ec2b225abc05b25c5"
  license "MIT"
  head "https://github.com/sloria/doitlive.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "febff82a0f9bb60bb3ba176a987e57d0a67a4c7eca14791a44f589d5380ede91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f1f51dda487b4e2a8e75f67926bc8280a823549c873b920d8084d9b0e52747"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eee1203b3334082aa0f174903b514cafb7ab140ba028994844ab05754793dfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "865f192f6f75a09b5aafae01ccca59605e26a06d6a3649a0694c57f68041a9be"
    sha256 cellar: :any_skip_relocation, ventura:        "5695d506a512de41ae2df8d9b129d40856f069515b75e36f24c87ba17487a188"
    sha256 cellar: :any_skip_relocation, monterey:       "de7fda25bc741b87a85f237ad2e79dcf79adc8818ebe360e2400dba9336e660c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "013fdc7846b78287d3b2dcd771a19c8d0890524ef0b1e6f5eca52f455a1b1aad"
  end

  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "six"

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

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin/"doitlive", "themes", "--preview"
  end
end
