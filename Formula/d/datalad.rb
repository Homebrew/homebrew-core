class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https://www.datalad.org"
  url "https://files.pythonhosted.org/packages/4e/3a/96d26ed9813c260294a497c8630fce1400da1112fbf478422cede3e9b9e8/datalad-0.19.3.tar.gz"
  sha256 "1002181d50fc8d8f7f434ec39b6daa70c1b7786d275c52a56aa04af26ca74e05"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "490d8975a148317c7e23a5f53171e4a63cc09a1bb101278f0c09ed0b0c559f8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2fba6dd8b5eb1cb30a3ffe8c1932aca0108288da94b01e5540abf2596166dfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac4c7dc240c47f10fdb45fa6a368675d5ebcd3a16d2b8dca6a88036763c7ac0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad886505ddbf1d3f829be3bf212c738a4446aa729661ea11dbf2652cbccc7af7"
    sha256 cellar: :any_skip_relocation, ventura:        "bb7591f30f921846eca5eb77fd21952aac7ffcd22027217afafdb9a2188ab2ae"
    sha256 cellar: :any_skip_relocation, monterey:       "32f0c14c229cc770aab5d04c30539a6c63e139ea88ae787fef775f0be7b16333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c950dba17d4aadfc9cf981fc0a4690d42516cac7c1e934ebfbce9ab5397d79d"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "git-annex"
  depends_on "p7zip"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.11"

  resource "annexremote" do
    url "https://files.pythonhosted.org/packages/3c/54/0b7636ee290fb7e4d03529e1c22326b226f04d67f0f3e9649cbc5177d315/annexremote-1.6.0.tar.gz"
    sha256 "779a43e5b1b4afd294761c6587dee8ac68f453a5a8cc40f419e9ca777573ae84"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/5f/d4/e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902/fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0c/84/e58c665f4ebb03d2fbeb28b51afb0743f846db18a5b594ed8b8973676ddf/humanize-4.8.0.tar.gz"
    sha256 "9783373bf1eec713a770ecaa7c2d7a7902c98398009dfa3d8a2df91eec9311e8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
    sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/a6/97/c7344bed881cc6f78b6231262436eb0c72615011fab4786d23d676ab77b0/keyrings.alt-5.0.0.tar.gz"
    sha256 "9d446cb47bbcea90ffa2ecc3e8003acf41573fc201bf44b4bf13bd0e11484828"
  end

  resource "looseversion" do
    url "https://files.pythonhosted.org/packages/64/7e/f13dc08e0712cc2eac8e56c7909ce2ac280dbffef2ffd87bd5277ce9d58b/looseversion-1.3.0.tar.gz"
    sha256 "ebde65f3f6bb9531a81016c6fef3eb95a61181adc47b7f949e9c0ea47911669e"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2d/73/3557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99/more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "patool" do
    url "https://files.pythonhosted.org/packages/1b/eb/ad3c94cb8cbc1d8b1c47471d2c43537a05fda2bdff54a7d8248873591691/patool-1.12.tar.gz"
    sha256 "e3180cf8bfe13bedbcf6f5628452fca0c2c84a3b5ae8c2d3f55720ea04cb1097"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/22/53/248b87282df591d74ba3d38c3c3ced2b5087248c0ccfb6b3a947bb1034c3/python-gitlab-3.15.0.tar.gz"
    sha256 "c9e65eb7612a9fbb8abf0339972eca7fd7a73d4da66c9b446ffe528930aff534"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"datalad", "create", "-d", "testdata"
    assert_predicate testpath/"testdata", :exist?
  end
end
