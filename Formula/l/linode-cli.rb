class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://files.pythonhosted.org/packages/a8/62/3c2d1a1c63df38533bf4ab5ed2a956168f3eedaca96fdea447bb69fc3b5c/linode-cli-5.48.2.tar.gz"
  sha256 "5c591987ecee00aab27591591d0cb2aaf3b33baeb99c9726ed405c6e752d2b76"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "51ee98fdd56fba0c51f81e691630851ee481ca7ce76b967ca1159232a392d4b5"
    sha256 cellar: :any,                 arm64_ventura:  "19866c8f8218572e6c6dac18b9a5b087afe18743b14b84aa3615001cf9c4eac7"
    sha256 cellar: :any,                 arm64_monterey: "3e84ce6e4456f1570df3f7c20dc7d62c4c96832dc3a76f2bcd29dfdcf3211d2f"
    sha256 cellar: :any,                 sonoma:         "1c192f311a1a07aede8f15be9d1db5dc824128c7ed31ea6776e39648815003b5"
    sha256 cellar: :any,                 ventura:        "ba15df9ae8e95503b55da7c4cf35dbf41ce338e4e204a3a20f884e324bf3d305"
    sha256 cellar: :any,                 monterey:       "b2274e40b7f60ee44ba47acffe84c4b25ab13cf885fa0b2da96f2bc5693f5e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27a36c1a88543de73b272ac02de55603173630c7d28cf0af6ea2040ba253db3f"
  end

  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "linode-metadata" do
    url "https://files.pythonhosted.org/packages/90/46/8cecde538b392d96abbb85b72bf3b31479b645d2853d6e64ff8888a3c37a/linode_metadata-0.2.0.tar.gz"
    sha256 "6877193ae74f8b798c35021167b969877d8b4b376f8fa0013c04f331d528000c"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi3" do
    url "https://files.pythonhosted.org/packages/94/0a/e7862c7870926ecb86d887923e36b7853480a2a97430162df1b972bd9d5b/openapi3-1.8.2.tar.gz"
    sha256 "a21a490573d89ca69ada7cbe585adb2fca4964257f6f3a1df531f12815455d2c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  def install
    # Prevent setup.py from installing the bash_completion script
    inreplace "setup.py", "data_files=get_baked_files(),", ""
    virtualenv_install_with_resources
    bash_completion.install "linode-cli.sh" => "linode-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linode-cli --version")

    require "securerandom"
    random_token = SecureRandom.hex(32)
    with_env(
      LINODE_CLI_TOKEN: random_token,
    ) do
      json_text = shell_output("#{bin}/linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end
