class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/42/4c/1ee8ca0aebca6ac985b65c65a443015dec969c2ed40e3599f3a801312d48/huggingface_hub-0.22.2.tar.gz"
  sha256 "32e9a9a6843c92f253ff9ca16b9985def4d80a93fb357af5353f770ef74a81be"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46b44bd7e9573af9a95283b6df7c99bb52163939abcbb403fe69d6574ab4e03d"
    sha256 cellar: :any,                 arm64_ventura:  "ac3c2fcd203a72da4f897fbc2d825335bb59e7e1e26540cf5d20fad5bcd37463"
    sha256 cellar: :any,                 arm64_monterey: "bb9f2e0475f23c66cf2e192249bd38f908ed9f990bf22bb0773b0839ce325052"
    sha256 cellar: :any,                 sonoma:         "e2fcabdd3ab0b14f21e4b9244753776f738ee3b8c0ac57aa59e5725242c3aa9c"
    sha256 cellar: :any,                 ventura:        "feecb3dfb1a350e49e16fbb99b8e5dc3037dbd381a5a82072b3f128ae3382947"
    sha256 cellar: :any,                 monterey:       "26b8f4be4dd077e8b31ffa2aeb72b167b3654939a9b7385bcfaa53d9eb301e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e8d28cc305f65b2b0141293b2bdf558de15311ac6c6563876c52d4be29b240"
  end

  depends_on "certifi"
  depends_on "git-lfs"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/ff/877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62/filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/8b/b8/e3ba21f03c00c27adc9a8cd1cab8adfb37b6024757133924a9a4eab63a83/fsspec-2024.3.1.tar.gz"
    sha256 "f39780e282d7d117ffb42bb96992f8a90795e4d0fb0f661a70ca39fe9c43ded9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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
