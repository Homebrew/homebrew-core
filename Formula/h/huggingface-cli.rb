class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/9d/83/0c07c6e6de04b097a4dd474a30492a650e5845256c4e4eed4397316248e4/huggingface_hub-0.23.4.tar.gz"
  sha256 "35d99016433900e44ae7efe1c209164a5a81dbbcd53a52f99c281dcd7ce22431"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef0e1adaea4e1af5b3d821c0b1845c43bfd120f953da8ae1ff236b8a83d4e504"
    sha256 cellar: :any,                 arm64_ventura:  "b2c0205415f3a9de8d715a807242bb1d7271ef0563510bc975bf53f35fcb1ad2"
    sha256 cellar: :any,                 arm64_monterey: "88cac4a04f4344f7588d41b3990289b0db8915c63e64c3f4ef7419f54d37529c"
    sha256 cellar: :any,                 sonoma:         "841642bb9dd977ad8c7959cfa65b92db9eacdd21d019a25d0300ecb6b13d1b44"
    sha256 cellar: :any,                 ventura:        "db920ca6bda1e049064a035dde6d58fe58799a84a1db1af8fe42df7b90ee5f0f"
    sha256 cellar: :any,                 monterey:       "d88bdadc092a3c4c93c2530a7c9b11df6eec840a6dafdfe5f3336bb895131db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1861c3f5dc6b9271b5f271bd3c509a0e64c183920bfd91b0008f726488e7ea0d"
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
    url "https://files.pythonhosted.org/packages/69/7d/73d36db6955bde2ed495ce40ce02c9a2533b8c7b64fd42a38b1ee879ea18/filelock-3.15.1.tar.gz"
    sha256 "58a2549afdf9e02e10720eaa4d4470f56386d7a6f72edd7d0596337af8ed7ad8"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/79/a5/3be4f3b4e941ee4526dd52f9c0a4ae6660ccb92e59b553e794015b249e97/fsspec-2024.6.0.tar.gz"
    sha256 "f579960a56e6d8038a9efc8f9c77279ec12e6299aa86b0769a7e9c46b94527c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
