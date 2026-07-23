class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https://www.datalad.org"
  url "https://files.pythonhosted.org/packages/e5/b3/a6241175a59a6c4c5ca172f7b0d71e942f951ac508778ae90b11b6e0009d/datalad-1.6.0.tar.gz"
  sha256 "612a8a60c31d50df435f859ef065fd528a5fc1c6c5b4bebd78edc6cea6e5f409"
  license "MIT"
  revision 1
  head "https://github.com/datalad/datalad.git", branch: "maint"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dd17d8dc9bd9ac8f6ffc5bc7ca81d5ac51d93914acdd567d0e7a634f2234804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2619960aa1ac32e0bf702b43aab97eb25d6505023329197ea72ad37e0411a1d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "525f04fbb5726a62609fc24c1de510f478c3f89e9f783d2e698f5ea1cd19f171"
    sha256 cellar: :any_skip_relocation, sonoma:        "6066c7392119c1777579bfc5a5f19666319952170538e9d9a653cb32a86844ee"
    sha256 cellar: :any,                 arm64_linux:   "6896b5712280aed9b39c4bd628a81cb4de27f4cc39dd7130abea6c1f919497ef"
    sha256 cellar: :any,                 x86_64_linux:  "d98052ce6c7cf81803edb6d92bb355465ee1603efbe727d1e705eeb14e6e3507"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "git-annex"
  depends_on "p7zip"
  depends_on "python@3.14"

  pypi_packages package_name:     "datalad[misc]",
                exclude_packages: ["certifi", "cryptography"],
                extra_packages:   ["jeepney", "secretstorage"]

  resource "annexremote" do
    url "https://files.pythonhosted.org/packages/5f/04/d7a39a2ab1de54fd7bfbb26feb4487baa71be4e10f9c677ee5ee6fade89b/annexremote-1.6.6.tar.gz"
    sha256 "5f78d0753c0763d95fc4c52050bd6212bb32457d32f6575dc66a83178e0283a7"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/10/9d/794d03504b8c72bf978a1ef93bc9e7d0867951bf5fbbe50881cd50fb26d5/boto3-1.43.33.tar.gz"
    sha256 "da6e400b2d11eb041fbbb2743ef3ffe6540889676ffdff0e628628e9b4f04cde"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/20/d5/8ec6df4e82bec2be4ac417f542736dc6cfe89152693337152421b336eb71/botocore-1.43.33.tar.gz"
    sha256 "74b3d5626ebeb2677fac1ca12ac975faf328e54349ceb4dcda17f50674d5b9b4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/19/b6/9df434a8eeba2e6628c465a1dfa31034228ef79b26f76f46278f4ef7e49d/chardet-7.4.3.tar.gz"
    sha256 "cc1d4eb92a4ec1c2df3b490836ffa46922e599d34ce0bb75cf41fd2bf6303d56"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/2d/18/7881a99ba5244bfc82f06017316ffe93217dbbbcfa52b887caa1d4f2a6d3/fasteners-0.20.tar.gz"
    sha256 "55dce8792a41b56f727ba6e123fcaee77fd87e638a6863cec00007bfea84c8d8"
  end

  resource "giturlparse" do
    url "https://files.pythonhosted.org/packages/8c/8a/b70b84cc78f9059d627f09560c81a11e8f046570d220a24e169489cad6c9/giturlparse-0.15.0.tar.gz"
    sha256 "9af3f1fd5c4a0cac94ddb283593635005646393ee0debbe330d1bdff8866bf2c"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
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
    url "https://files.pythonhosted.org/packages/36/cf/ea4ef2920830dea3f5ab2ea4da6fb67724e6dca80ee2553788c3607243d0/jaraco_functools-4.5.0.tar.gz"
    sha256 "3bb5665ea4a020cf78a7040e89154c77edadb3ca74f366479669c5999aa70b03"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/5c/7b/e3bf53326e0753bee11813337b1391179582ba5c6851b13e0d9502d15a50/keyrings_alt-5.0.2.tar.gz"
    sha256 "8f097ebe9dc8b185106502b8cdb066c926d2180e13b4689fd4771a3eab7d69fb"
  end

  resource "looseversion" do
    url "https://files.pythonhosted.org/packages/64/7e/f13dc08e0712cc2eac8e56c7909ce2ac280dbffef2ffd87bd5277ce9d58b/looseversion-1.3.0.tar.gz"
    sha256 "ebde65f3f6bb9531a81016c6fef3eb95a61181adc47b7f949e9c0ea47911669e"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "patool" do
    url "https://files.pythonhosted.org/packages/2c/e2/215c7d5efd40cf9b33b4943055b47c22cb0851383facdaedd919e30de90a/patool-4.0.5.tar.gz"
    sha256 "1c8bbbbe1f421181bf7055ada975befb024c1677449e9d36f42bb45ac69f8b4c"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/cc/96/c20b37e7fd86481e1bf2b1922e84b98dc5477fd9aafd30e5c5086f94d922/python_gitlab-8.4.0.tar.gz"
    sha256 "f36f20ec3f09138f3b12089394941f4dbe5a407021bed71b70a04bbdd37b8a74"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/f6/94/dcdaeb1713cab9c84def276cfac7388b17c7d9855bbcfe88d77e4dbafd44/s3transfer-0.19.0.tar.gz"
    sha256 "ce436931687addc4c1712d52d40b32f53e88315723f107ffa20ba82b05a0f685"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/87/d7/0535a28b1f5f24f6612fb3ff1e89fb1a8d160fee0f976e0aa6803862134b/tqdm-4.68.3.tar.gz"
    sha256 "00dfa48452b6b6cfae3dd9885636c23d3422d1ec97c66d96818cbd5e0821d482"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)
    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "datalad", "--shell")
  end

  test do
    system bin/"datalad", "create", "-d", "testdata"
    assert_path_exists testpath/"testdata"
  end
end
