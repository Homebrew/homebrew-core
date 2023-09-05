class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/38/a5/eac7345cff754bfe84933a99811d720e892671cccfcac5ac023f66efdc5f/huggingface_hub-0.16.4.tar.gz"
  sha256 "608c7d4f3d368b326d1747f91523dbd1f692871e8e2e7a4750314a2dd8b63e14"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0628ee8229337f3a92745c4bec5ee5de18b1f76d67cd0490e68bf6a386dae00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f94b10e82fa4e71e4c8982cd1d86383ebcda06c66e9373fa0d4b2ed098660541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19004ae27aa5557c14dd7aeeebb0fb766c3a9f5cfbc4c821d171286842ea4533"
    sha256 cellar: :any_skip_relocation, ventura:        "077fa0d56c16b1cd2355b2d06a8bb323aed13f4001ae110bb5099bf76a6ed130"
    sha256 cellar: :any_skip_relocation, monterey:       "c6134b593056bbde352859141fc05779b5199b79003424498f2f92fad1f22a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "6559e08f53c10b49043a4afb8978703c42f182319954c276d6cd3015e0e4dd14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fe4ddffd970c93270442b4fc19cd6932f3dbcf4768ea1229930e01b85c7a185"
  end

  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/14/e4/33a5c4635cff37ef6eb66608c675ae678b48baa6e73b331536cf2cbf18a1/fsspec-2023.6.0.tar.gz"
    sha256 "d0b2f935446169753e7a5c5c55681c54ea91996cc67be93c39a154fb3a2742af"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end
