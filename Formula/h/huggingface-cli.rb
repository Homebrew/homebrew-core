class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/06/0c/e714259b4ba55767a5358ac0182c20dc10b065fd9712faa4bf2f876a499a/huggingface_hub-0.20.3.tar.gz"
  sha256 "94e7f8e074475fbc67d6a71957b678e1b4a74ff1b64a644fd6cbb83da962d05d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1b0236132b92295f8c453fd1e6737f97ff698b51bf84d2682be2fa05a9a3844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b1e5119d4302cec909a5a77acb45165d7bb8cb57f2c246c535336cabec1f14c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a512ab0602c05097ddffd3eb35bbf30b1a75be30829ac6713647e9bf48a28851"
    sha256 cellar: :any_skip_relocation, sonoma:         "211313857cfc4419c17846cab7d5587b56ae77fe58cc276f20b7c3c52308fe75"
    sha256 cellar: :any_skip_relocation, ventura:        "7fa89d4fb53bb7ae7ead9c7cbab08b7a734aa1237c1286ad62e1d937fe259550"
    sha256 cellar: :any_skip_relocation, monterey:       "f05332a73d18630b831f18d28d3f1bfb199ad78887c87ad852511b992f94e7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec16e7b669e955e0f7a4d5cc5cbeddddab3272d28c089593068e941b5d5a7e8"
  end

  depends_on "python-setuptools" => :build
  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/28/d3/c2e0403c735548abf991bba3f45ba39194dff4569f76a99fbe77078ba7c5/fsspec-2024.2.0.tar.gz"
    sha256 "b6ad1a679f760dda52b1168c859d01b7b80648ea6f7f7c7f5a8a91dc3f3ecb84"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
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
