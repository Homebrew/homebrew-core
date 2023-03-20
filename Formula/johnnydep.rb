class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/31/d3/38a7a2727610ca1b128997419acca1f25225fa2472517aea6b9f465dfc1c/johnnydep-1.17.5.tar.gz"
  sha256 "edc6c95e2ee1ab433d69afddaa85af4e4ffc040ff607bdb579b72c4e35d15b8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb81b2dc320d3c3f1bf5a91cde07ee5b962c51ceb9e01fad8c796cd4b8668e7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d98351267c04a3214887cd27cb913af31b6fbc2244ab280ff0f24139c76c81f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67a079bd1d0c8003b8d1ec913310c23e311a521e14e66eaa0cc9ae8ad5c9c613"
    sha256 cellar: :any_skip_relocation, ventura:        "79fe2488c6f0fe737687b8a82e53b2c7a2da28185ef54e4fdac818f415f3af79"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b2085be14a69c3b812fde38a6433ce840d91fe3b2e5a86b622d0fd11687a4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2ac9d56c4ecc02ed60cdc46f5aad898f070a447382cfa99f0e3f7ca1751b6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "752768769097065128c953e0bcfb099285ab7cc78af84729d3d595c09f48ddb9"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/a9/9b/4236af056671ba03c788b7398785912b741fb47b6683feab96501f66fc5b/structlog-22.3.0.tar.gz"
    sha256 "e7509391f215e4afb88b1b80fa3ea074be57a5a17d794bd436a5c949da023333"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a2/b8/6a06ff0f13a00fc3c3e7d222a995526cbca26c1ad107691b6b1badbbabf1/wheel-0.38.4.tar.gz"
    sha256 "965f5259b566725405b05e7cf774052044b1ed30119b5d586b2703aafe8719ac"
  end

  resource "wimpy" do
    url "https://files.pythonhosted.org/packages/6e/bc/88b1b2abdd0086354a54fb0e9d2839dd1054b740a3381eb2517f1e0ace81/wimpy-0.6.tar.gz"
    sha256 "5d82b60648861e81cab0a1868ae6396f678d7eeb077efbd7c91524de340844b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/johnnydep johnnydep")
    resources.each do |r|
      assert_match r.name, output
    end
  end
end
