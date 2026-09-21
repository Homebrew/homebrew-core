class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https://www.datalad.org"
  url "https://files.pythonhosted.org/packages/0c/73/d4d528b995333c195cee46a84593d1b8be9ce73d8f26b6e19ee53917641c/datalad-1.6.3.tar.gz"
  sha256 "10b012cf403a76dcad5c9df230db4dfa17c4027b7eeb77daeeccf84b7890a1af"
  license "MIT"
  head "https://github.com/datalad/datalad.git", branch: "maint"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78e94eae761dbe50b7317de3f1aaf03a463fb39151acae5d4185c6c72a238a16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96767935e29432ab263782e4883725493d3e226b776b113e12e9055f6972632f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "801965dbe8d54f6f7aa2078cb1a8c6098d724c502870361065e03b854284c87e"
    sha256 cellar: :any,                 arm64_linux:       "8016e1bf5affd375b40922fac1b73f5c595088fe869277bdd0b981f19cd31596"
    sha256 cellar: :any,                 x86_64_linux:      "05a0cf93c3fa928b57f14b18216d75449f22df9c9caacbedcd8fa792c5ac253f"
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
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/16/b6/41173fa75983750c794e9b64017a3203407725a0e8c9c7f6de39686dc97b/boto3-1.43.96.tar.gz"
    sha256 "30fb2b5467ef5175ed48f43c06c435eec5da841594a5d7653c4da679df0740fc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d2/8d/a3d51a726b62585d032bc55eaa45068dec381d51329cca0140f9c233b792/botocore-1.43.96.tar.gz"
    sha256 "3ef7c8c40738bb42a40eb0ac3dc2d9f1698946541874ae9b505e49f289272805"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/b1/51/cd61c567092a6cec796144510a68aff158ebfc1df82950a45bae65f28413/chardet-7.6.0.tar.gz"
    sha256 "93d9df6089ded42ed1fe9f57e272c0b74bd0464d45c0c7d50f09f26f31105c3c"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
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
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
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
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
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
    url "https://files.pythonhosted.org/packages/6d/44/ea2100ec54d30c46ee9dba10a3bfb79b655e96c6df237238a3234c75869b/msgpack-1.2.2.tar.gz"
    sha256 "9eb0b0e602064527a045ea28c4f174ed69383587e29cebe28947e3b84106eb2a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "patool" do
    url "https://files.pythonhosted.org/packages/1a/3c/328a6a4e3da061efbd8d69e6b8d7cd5ee37877f9782c68e5b370f4a10dbf/patool-4.1.0.tar.gz"
    sha256 "54c669b2af0f5e46d59a53f02ca4f83d53b3a7a25d50e97778582da7cea65daf"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/b9/8adc4e1b422b27fd88540ec7bf1f406f77ef393ec070e26fc430e914cde8/platformdirs-4.11.9.tar.gz"
    sha256 "e2c66a8d384596cd98e3c4aea2d761df7bac95d9d8a2cc3946daa8cdafdaebc1"
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
    url "https://files.pythonhosted.org/packages/26/55/8050293b360a29218a15892c2b936e286a69fd4f5d2cf54c7cbe19d34b47/python_gitlab-8.5.0.tar.gz"
    sha256 "628529ec4ce1f9a7ba2c145b2cf5e4eeca3015418e504b2e6fba70171b6b1b59"
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
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
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
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
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
