class Mk < Formula
  include Language::Python::Virtualenv

  desc "Wrapper for auto-detecting build and test commands in a repository"
  homepage "https://mk.readthedocs.io"
  url "https://files.pythonhosted.org/packages/75/9e/dcc7813d9f7133f8d384eca24a4d4bb0cb056abcc53f1f170b8353084feb/mk-3.0.0.tar.gz"
  sha256 "0a041a3620057165f155b8372469d8ab55ae94dd91d6e27723ab9a7de1aa2086"
  license "MIT"
  revision 10
  head "https://github.com/pycontribs/mk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71b0e9cf0a2afe414eb57330ffd9e9d77f035e4cc5a563c6a2b164c98cfc327f"
    sha256 cellar: :any, arm64_sequoia: "5abf69e39d6b27f36d8a73a8d00623d8cdde04a3161cce739738954ac4549292"
    sha256 cellar: :any, arm64_sonoma:  "eb3d192be40004806f6dc4c153bdbba04b959149037a09aed622cc27d22f95ee"
    sha256 cellar: :any, sonoma:        "2d84dbcd0645fcc451f42222716890a97653aae9ed7d8b2804f3d1a768be9ac8"
    sha256 cellar: :any, arm64_linux:   "d9afeb58611154d99a7f843ea145c959f7c4d2fcba955949cc919ad27aa7a1bc"
    sha256 cellar: :any, x86_64_linux:  "5d514cc2d1896903e38b253a6995d5f62455f1f868e12a1d56eb34eede425f27"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  on_linux do
    depends_on "cryptography" => :no_linkage
  end

  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   %w[jeepney secretstorage]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "build" do
    url "https://files.pythonhosted.org/packages/78/e0/df5e171f685f82f37b12e1f208064e24244911079d7b767447d1af7e0d70/build-1.5.0.tar.gz"
    sha256 "302c22c3ba2a0fd5f3911918651341ebb3896176cbdec15bd421f80b1afc7647"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/17/24/0e0c12cb6f7cb864779a9d2fefee9ca91838f6db402c8780c9d28a8d7ebe/gitpython-3.1.53.tar.gz"
    sha256 "06ae8d9623b0ed0d67b8adeac5c7008d0a5a404b087a9e0d0c7163bdd3a6b497"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "nh3" do
    url "https://files.pythonhosted.org/packages/5e/1b/ef84624f14954d270f74060a19fc550dd4f06656399447569afb584d8c06/nh3-0.3.6.tar.gz"
    sha256 "f3736c9dd3d1856f80cd031715b84ca75cda2bbb1ac802c3da26bfce590838d7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/02/51/d3a6ea424652c60f05600d8c2e01a55c913755e7cdad64afabbd1aa16f44/readme_renderer-45.0.tar.gz"
    sha256 "030a8fac74904f8fba11ad1bb6964e3f76e896dc7e5e71f16af190c9056696d1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/d7/22/991efbf35bc811dfe7edcd749253f0931d2d4838cf55176132633e1c82a7/subprocess_tee-0.4.2.tar.gz"
    sha256 "91b2b4da3aae9a7088d84acaf2ea0abee3f4fd9c0d2eae69a9b9122a71476590"
  end

  resource "twine" do
    url "https://files.pythonhosted.org/packages/e0/a8/949edebe3a82774c1ec34f637f5dd82d1cf22c25e963b7d63771083bbee5/twine-6.2.0.tar.gz"
    sha256 "e5ed0d2fd70c9959770dce51c8f39c8945c574e18173a7b81802dab51b4b75cf"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/37/78/fda3361b56efc27944f24225f6ecd13d96d6fcfe37bd0eb34e2f4c63f9fc/typer-0.27.0.tar.gz"
    sha256 "629bd12ea5d13a17148125d9a264f949eb171fb3f120f9b04d85873cab054fa5"
  end

  resource "typer-config" do
    url "https://files.pythonhosted.org/packages/21/83/816a6556bb8f4acaa10e908f609557be00f3df2cae98c4216e4b75235c45/typer_config-1.5.1.tar.gz"
    sha256 "78be341f6894f44d6f2dc6b01f6eef83b9381d16c11341b12d6b8a245a3fb451"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)

    generate_completions_from_executable(bin/"mk", shell_parameter_format: :typer)
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: ## description
      	@echo hello from mk
    MAKE

    system "git", "init", "--initial-branch=main"
    assert_match version.to_s, shell_output("#{bin}/mk --version")
    assert_match "all", shell_output("#{bin}/mk commands 2>&1")
    assert_match "hello from mk", shell_output("#{bin}/mk all 2>&1")
  end
end
