class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https://cli.codecov.io/"
  url "https://files.pythonhosted.org/packages/96/73/e18aaee2b3638528cfbece0615c34a59489f9063413744a31149558a0645/codecov-cli-0.6.0.tar.gz"
  sha256 "25d23c14d99f58c071d1db4d78aa9774a7407054cef49ca676ad805d1daaefe1"
  license "Apache-2.0"
  head "https://github.com/codecov/codecov-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b10c0ff06ade990fd1826e4c04226e0a5fb71f7f0f68f6a1b9486b9ddb9a8411"
    sha256 cellar: :any,                 arm64_ventura:  "d3a05e079d158e3cd5caa8df7c0bcfaaae988bd38da658b42dfd5b836d0f639c"
    sha256 cellar: :any,                 arm64_monterey: "0a0e5128c411c632872d9205fafd4fb0e73a82cb670954f3c6af1a8ea0692c1e"
    sha256 cellar: :any,                 sonoma:         "8b4f7f5017b7c45f15b65ab5d71ebf3b67fe4a954b46c07243e35c21e0a6bfb7"
    sha256 cellar: :any,                 ventura:        "71a06555f6d603d9a37a1dab09ee2d3ab27c6966781794d621184ac5adecbe58"
    sha256 cellar: :any,                 monterey:       "71a186b9ee4b9ac29c6b50fcc119e9cdbbacf62a8a483e6364100bfb94393860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "295c7d8c9d41ba614503b3a07f4358a0d8d360e3ac4bdb3fa1097ea8b61fffc0"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/e6/e3/c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2/anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/b3/e02f4f397c81077ffc52a538e0aec464016f1860c472ed33bd2a1d220cc5/certifi-2024.6.2.tar.gz"
    sha256 "3cd43f1c6fa7dedc5899d69d3ad0398fd018ad1a17fba83ddaf78aa46c747516"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/61/42/5c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2/httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f5/50/04d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72d/httpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "ijson" do
    url "https://files.pythonhosted.org/packages/6c/83/28e9e93a3a61913e334e3a2e78ea9924bb9f9b1ac45898977f9d9dd6133f/ijson-3.3.0.tar.gz"
    sha256 "7f172e6ba1bee0d4c8f8ebd639577bfe429dee0f3f96775a067b8bae4492d8a0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/6d/db/b949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5/responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "test-results-parser" do
    url "https://files.pythonhosted.org/packages/fa/1f/35f5b23beb148c36285bfe9722adeaef976814670ebf9bd8129356a283c8/test_results_parser-0.1.0.tar.gz"
    sha256 "0034281a4b406d7f072fc5ac1f5e44660e3c23bc92f2e7284862ee097f9626ee"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/4a/64/71b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4/tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  # Fix SyntaxWarning's on python 3.12: https://github.com/codecov/codecov-cli/pull/458
  patch do
    url "https://github.com/codecov/codecov-cli/commit/ef2f435e01559ae85ec4db0c41b8377214b4f3c5.patch?full_index=1"
    sha256 "ba394ec6df7f368d2a8ddbb69cfbeec7b91e96d1077e3b551dad95d1db257d8e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "codecovcli, version #{version}\n", shell_output("#{bin}/codecovcli --version")

    # Unfortunately `shell_output` doesn't capture standard error
    output = shell_output(["#{bin}/codecovcli create-report --commit-sha #{SecureRandom.hex(40)}",
                           "--slug test/repo --token #{SecureRandom.hex(10)} 2>&1"].join(" "))

    ["No config file could be found. Ignoring config.",
     "Process Report creating complete",
     "Report creating failed: {\"detail\":\"Not valid tokenless upload\"}"].each do |l|
       assert_match l, output
     end
  end
end
