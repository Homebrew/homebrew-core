class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/6a/18/42d8bb8a7a87e28f024d4c6ec380ad135836873679e60a641813d22407f7/huggingface_hub-0.15.1.tar.gz"
  sha256 "a61b7d1a7769fe10119e730277c72ab99d95c48d86a3d6da3e9f3d0f632a4081"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abc9363573ec9495b39942c3d4598e1760c60771d5f2925338e622da8def7c51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47eb1136cab13c0d5c9efcb2d8c120f027f12fb1c9de4a11d49235c572e8a469"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72bf7013b1c93b6fc18999eaeff28b4e9bf1e34811b87cfb075f3c631eb85bdf"
    sha256 cellar: :any_skip_relocation, ventura:        "dddedcc58e454cdea833381ec8c9c26ea5734e5711c6eb7484f0021a0c4ae624"
    sha256 cellar: :any_skip_relocation, monterey:       "2aa11daf10c5550f27cc7e2af4c6c9fb5d8bf4e107a0d31e0f7e68b10cf8db43"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0d9e050be3185ce3f67fb81918972c71c70d398123d4d87a47ee8b6a297c657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "671b84a8ada3ee02b15f11d1399418d4f65ec6137777d6e06cf8f95b52662802"
  end

  depends_on "git-lfs"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/4e/5f/faee1c6261997e5b0782f48db9d01dc8ce7aa817d2016dd5cd64c60b1d86/fsspec-2023.5.0.tar.gz"
    sha256 "b3b56e00fb93ea321bc9e5d9cf6f8522a0198b20eb24e02774d329e9c6fb84ce"
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
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
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
