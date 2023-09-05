class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://files.pythonhosted.org/packages/38/70/9b9f01a0f10bf17740c8b0c47681f6e6751f7fd11de67bce79c3cb6639dd/linode-cli-5.42.1.tar.gz"
  sha256 "ff8a7f1cacb7f6b587263cf39699f55cc27ac20f61d96131d8c18b3950ca7a04"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62a3df0dc30c26f5839bc78afe7b82ae271d4ca75d9b0594b1bfca4458eb5d9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf4ad1338b5e7a0054617a8c0ef3added0495445c133a689892e5340ad43395"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80c1f330e9fd126d9157e585970cac28a5e1d7c41946736b54060106d36aa937"
    sha256 cellar: :any_skip_relocation, ventura:        "0e63d6a122d2edaf9727cc81b9cf30c7f65d47f1de67460e512bf0cb561b8ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "8613234b21dea093c4487ed0fd9badc785b70085add36bb295053621f0dfbde4"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f1510f317eea513039a8a9fdb6a61b00eb449be321e044b19f6191cbe70da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f27e129e39a2c6ccad44553f345ce6a61ffed2960b4a6a6c8286b8537e11f639"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "linode-api-spec" do
    url "https://raw.githubusercontent.com/linode/linode-api-docs/refs/tags/v4.161.0/openapi.yaml"
    sha256 "464d23edcae38c927f1ac81b287db7f559c6ffac93aa2dfaf5e718834d1097bd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https://files.pythonhosted.org/packages/7b/09/58889a60b8b4c1796b980b09b1fac752e5f29ff55bce93eeb900aff64389/openapi3-1.8.1.tar.gz"
    sha256 "cc696ce11088a7fbb5f366307b0aebd115528adfb401b3e817c520adf2e68f86"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ad/1a/94fe086875350afbd61795c3805e38ef085af466a695db605bcdd34b4c9c/rich-13.5.2.tar.gz"
    sha256 "fb9d6c0a0f643c99eed3875b5377a184132ba9be4d61516a55273d3554d75a39"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name == "linode-api-spec" }
    buildpath.install resource("linode-api-spec")

    # The bake command creates a pickled version of the linode-cli OpenAPI spec
    system libexec/"bin/python3", "-m", "linodecli", "bake", "./openapi.yaml", "--skip-config"
    # Distribute the pickled spec object with the module
    cp "data-3", "linodecli"

    inreplace "setup.py" do |s|
      s.gsub! "version=version,", "version='#{version}',"
      # Prevent setup.py from installing the bash_completion script
      s.gsub! "data_files=get_baked_files(),", ""
    end

    bash_completion.install "linode-cli.sh" => "linode-cli"

    venv.pip_install_and_link buildpath
  end

  test do
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
