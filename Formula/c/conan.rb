class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://conan.io"
  url "https://files.pythonhosted.org/packages/54/89/5b9d6cca677e57b67560aa3b7f82728127889ce74bb91171ded6f28e42b8/conan-2.28.1.tar.gz"
  sha256 "e4ed10123751bf2931c32c33cadafe4881c72e1c22a1c97b19cb75780692fae5"
  license "MIT"
  head "https://github.com/conan-io/conan.git", branch: "develop2"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a557f2856b6a4dc974425ac86b18e3f9c7f290211ee496a3c7e43e6495d96937"
    sha256 cellar: :any,                 arm64_sequoia: "98d4701a204346ecf652c70d561e9fea05737778cafa1bed8061d7bdb0b0e54e"
    sha256 cellar: :any,                 arm64_sonoma:  "025c673b95520da3a117762babb6b2d58f08d67efbeacd88689c8cafca18ad13"
    sha256 cellar: :any,                 sonoma:        "70888da2cb609569190c1a036a1764f311201e9080718d69676a0d5bff3bb103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ded922d3af6aab497ba3a45d82827123cc198f40bd3c8031f65715885845216b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "143963896e1fe0932d156f863026569362c5db4cc8fa600a1c4f0c03b2820943"
  end

  depends_on "pkgconf" => :build
  depends_on "cmake" => :test
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "distro"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/2d/18/7881a99ba5244bfc82f06017316ffe93217dbbbcfa52b887caa1d4f2a6d3/fasteners-0.20.tar.gz"
    sha256 "55dce8792a41b56f727ba6e123fcaee77fd87e638a6863cec00007bfea84c8d8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "patch-ng" do
    url "https://files.pythonhosted.org/packages/da/b6/8ea8095f964f93567bbe28709298b30104ad418b50d4217538387bf48f7d/patch_ng-1.19.1.tar.gz"
    sha256 "036a3cc00134ec53f37e92333958ee75e117f2e62a5ec2b85c7122e5e815c29e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"conan", "profile", "detect"
    system bin/"conan", "install", "--requires=zlib/1.3.1",
                                   "--build=missing",
                                   "--lockfile-out=conan.lock"
    lockfile = JSON.parse(File.read("conan.lock", mode: "r"))
    refute_predicate lockfile["requires"].select { |req| req.start_with?("zlib/1.3.1") }, :empty?
  end
end
