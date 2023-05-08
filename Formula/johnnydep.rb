class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/dd/06/5379720d3319782a62aac89bc8b0a8dc4d2a52bba7c4b897406564c9ed3a/johnnydep-1.19.0.tar.gz"
  sha256 "b4f4f9cd419f82d0db55c6a8ae9f245d4f2ab4c6c788c276fa3cd147497015cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f444ac6b3b3e6234c048c8b68d37af3e44bb0c4c1f6282c016f1fc41de13715c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a78cad6ca3de0b3032b862ac6f0c055e44dc2c7396ca8188b48e4f93503ed5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0455585d1d7134bcf14dee621d9c8750343c1c850003c971434527afa5b677b"
    sha256 cellar: :any_skip_relocation, ventura:        "f66f6b947b62247ebf837ac8b246fcb5b23a541cc7c9fe8e027cee581a06e65c"
    sha256 cellar: :any_skip_relocation, monterey:       "f62adef5e1b86d677eb83f2b59a7f0d84471b68886ddced2986058996c03f2bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a7a70e0678fbbdcdfd627a4efff1513d262d3cd6a6592c0ea19f2cfacf240b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c659887453b4d90fc117a106e91b254f0e69c116c98f3db2fbddea6b3fb8cd06"
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

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fc/ef/0335f7217dd1e8096a9e8383e1d472aa14717878ffe07c4772e68b6e8735/wheel-0.40.0.tar.gz"
    sha256 "cd1196f3faee2b31968d626e1731c94f99cbdb67cf5a46e4f5656cbee7738873"
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
