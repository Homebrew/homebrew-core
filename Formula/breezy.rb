class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org"
  url "https://files.pythonhosted.org/packages/09/71/b75b6f8872516a3fb5fa20f98f32097ac126a847cb90c5c9189fac5e47f9/breezy-3.2.0.tar.gz"
  sha256 "97028f93e53128085f22051bd713cb27fcdae7755d1de9e606bafce514e9129b"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "346e68c4f53bd4dbafca6cc99b506aec39e7832404e8b71ed14a1aecff098d53"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e752e52c7483cf0bb746b39767e3d993e0625f1cff5d8d5136a9a739c10c8de"
    sha256 cellar: :any_skip_relocation, catalina:      "749d279b1025328b55c6cdefab609d7c783d08c776b2d9b36c8c3b47aa893779"
    sha256 cellar: :any_skip_relocation, mojave:        "6f121c4a7496b887843277ea099ac7980cfdcc786df32ebc2f48de1e18220f7e"
  end

  depends_on "cython" => :build
  depends_on "gettext" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/31/02/791c17b92e6d04c43f9b318c95a3f3c3e1ea718aa72ad95b9dac147895fa/dulwich-0.20.21.tar.gz"
    sha256 "ac764c9a9b80fa61afe3404d5270c5060aa57f7f087b11a95395d3b76f3b71fd"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/90/ca/13cdabb3c491a0ccd7d580419b96abce3d227d4a6ba674364e6b19d4d67e/patiencediff-0.2.2.tar.gz"
    sha256 "456d9fc47fe43f9aea863059ea2c6df5b997285590e4b7f9ee8fbb6c3419b5a7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
