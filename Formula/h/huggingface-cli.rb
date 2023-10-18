class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/c8/6e/95d9518908ec9dcf7a97c0b0a14ddbf07e17158b3d4cefc522b91f823ae5/huggingface_hub-0.18.0.tar.gz"
  sha256 "10eda12b9c1cfa800b4b7c096b3ace8843734c3f28d69d1c243743fb7d7a2e81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56863eff271e581c83b11a5614846c54454e6816b6dd7d18ebbab18f4a62daf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "471861360a48e6d19814618d5d1e7f9aeb7c45a01e8f044954785f0b5e779e33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b751506f3a08b73e08d6ee63646785cd8e7a038e07da5ab82d2d5356b1a8d009"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a0543592cb9f151984d50f338c0494243864228dff666024ca5d09c914849c4"
    sha256 cellar: :any_skip_relocation, ventura:        "d4ac8616a82363b1941cd2ef7d504355109426732afb36ff991905623f35abce"
    sha256 cellar: :any_skip_relocation, monterey:       "e3b5a54b22225151b0a6c0334239c0a3bdcf29cc57d9d2c39ca77c23578b8b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b3fcf12b32e09095c33012aa5fbab7c653d6678e2cd403578a9d01d2ae6a4b8"
  end

  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/bd/c1/b9dbe600903f9ac2401e42f38cb376130485a6d0db611f60ab05fa8d21fc/fsspec-2023.9.2.tar.gz"
    sha256 "80bfb8c70cc27b2178cc62a935ecf242fc6e8c3fb801f9c571fc01b1e715ba7d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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
