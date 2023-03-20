class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/7c/c6/bc3e71647d0fcc757eb04fe2e5ea70fe6394cf3b21159f268f5a10cb805b/huggingface_hub-0.13.3.tar.gz"
  sha256 "1f95f65c5e7aa76728701402f55b697ee8a8b50234adda91fbdbb81038fbcd21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f76c1d41ce2ba174e37b5434d7710dec224ca32c3dada1164fc79fb50c336f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ed1c9302075fb9654e5f8dd7029c823e95ca318a07081e46dceb2429db7382e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a77703a0ca34647ab094920f1eb3057bb9d207dce828e10fa3f25e195ddd2fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ed5330cdc6c037e9fcaf799a8c4ae8801abce3a0d6ce914c3375c7c66d6a53"
    sha256 cellar: :any_skip_relocation, monterey:       "1c1ee5dee4e6caea3c9918236c518ce82a800e2f6b7c45e15a95befe849e37a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a608f18cc52af1eddc6393451e92dd9e4eb51ca5bfaf79830a68a0f044300356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc81f8a8b85865754d0b07e8600c396a72a3e2574a9d98b02635b50770ed710"
  end

  depends_on "git-lfs"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4f/1f/6e1b740698069650b245744957a25957d599b953550a959ab2a584a8825b/filelock-3.10.0.tar.gz"
    sha256 "3199fd0d3faea8b911be52b663dfccceb84c95949dd13179aa21436d1a79c4ce"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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
