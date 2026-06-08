class Ggshield < Formula
  include Language::Python::Virtualenv

  desc "Scanner for secrets and sensitive data in code"
  homepage "https://www.gitguardian.com"
  url "https://files.pythonhosted.org/packages/51/d5/54067ee60dee03485ceab3f5f3f998fed550ffb087e63a25635797cb0e77/ggshield-1.51.0.tar.gz"
  sha256 "e7f21d6a2693ab7c546f1be84d218e5cd69357ed5ac2e0bfb92fb93cfa367edb"
  license "MIT"
  head "https://github.com/GitGuardian/ggshield.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f08899e87d30880f2287ff60660dcebd3b2bc7ffea0ed4db0328fca468748722"
    sha256 cellar: :any,                 arm64_sequoia: "dbcc1c09a98bc911df6f65d43518e86a9714e5d534071f6312cc2c1b3b63b49d"
    sha256 cellar: :any,                 arm64_sonoma:  "72d7094668824cd9e5d9676cd1edb1eda7470d857f4991a8e7e96917b50855ff"
    sha256 cellar: :any,                 sonoma:        "3caf6b2ba40c020accd49c97f2cd94e5c4623809056b37623f9210d7f863416b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "143dc26c62541bc06d2da82efdb4298122c5f197734e96660dad7cbd0d1751c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8099c57e2ce4d94c43bdf4f86736cd7aa9983fdd6418b8354c8d4b99cc0b4504"
  end

  depends_on "pkgconf" => :build # for `rfc3161_client`
  depends_on "rust" => :build # for `rfc3161_client`
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic],
                extra_packages:   %w[jeepney secretstorage]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
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

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/75/1f/d3818863e4be96bd641c4643c535a98f0fa2a12efa7c8ba35f763fa778ee/loguru-0.6.0.tar.gz"
    sha256 "066bd06758d0a513e9836fd9c6b5a75bfb3fd36841f4b996bc60b547a309d41c"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/55/79/de6c16cc902f4fc372236926b0ce2ab7845268dcc30fb2fbb7f71b418631/marshmallow-3.26.2.tar.gz"
    sha256 "bbe2adb5a03e6e3571b573f42527c6fe926e17467833660bebd11593ab8dfd57"
  end

  resource "marshmallow-dataclass" do
    url "https://files.pythonhosted.org/packages/20/f2/1af94d8e8432ddd80e30983b3c7fdeb4cf7c9b0790d6d4855c4343dbecde/marshmallow_dataclass-8.5.14.tar.gz"
    sha256 "233c414dd24a6d512bcdb6fb840076bf7a29b7daaaea40634f155a5933377d2e"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "notify-py" do
    url "https://files.pythonhosted.org/packages/06/2b/fc68aeed5108185922c5469484e15c192dff01d61eddfab0c1c256e4f54c/notify_py-0.3.43.tar.gz"
    sha256 "16ee146d48f16bae5dad233db66014a387efd2c6ed2c4caf1e08aef432070513"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pygitguardian" do
    url "https://files.pythonhosted.org/packages/52/d9/15e6d313c47c1e8753d7c0a274717b8841f34e9e187ba8a9f5b9598096f4/pygitguardian-1.30.0.tar.gz"
    sha256 "fd6a43a2650d181c06d3e0a5c38b7a9ed9e4868bdd1997ce4e6c5863c94de9fe"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/75/65/db64904a7f23e12dbf0565b53de01db04d848a497c6c9b87e102f74c9304/PyJWT-2.6.0.tar.gz"
    sha256 "69285c7e31fc44f68a1feb309e948e0df53259d579295e6cfe2b1792329f05fd"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f5/d7/d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1/python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rfc3161-client" do
    url "https://files.pythonhosted.org/packages/66/a7/be3b086133a87d595e7b11564931d5e5283edeeabba05dfee636a34b4dab/rfc3161_client-1.0.6.tar.gz"
    sha256 "9969262fe6c08ecce39f9fe3996cf412187793834a022a643803090db5aae6b4"
  end

  resource "rfc8785" do
    url "https://files.pythonhosted.org/packages/ef/2f/fa1d2e740c490191b572d33dbca5daa180cb423c24396b856f5886371d8b/rfc8785-0.1.4.tar.gz"
    sha256 "e545841329fe0eee4f6a3b44e7034343100c12b4ec566dc06ca9735681deb4da"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "securesystemslib" do
    url "https://files.pythonhosted.org/packages/c2/dd/d1828dce0db18aa8d34f82aee4dbcf49b0f0303cad123a1c716bb1f3bf83/securesystemslib-1.3.1.tar.gz"
    sha256 "ca915f4b88209bb5450ac05426b859d74b7cd1421cafcf73b8dd3418a0b17486"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  resource "sigstore" do
    url "https://files.pythonhosted.org/packages/98/c3/84ec81173ade0dba5613feea577308cde4e69045cc804d02953e3a40922c/sigstore-4.2.0.tar.gz"
    sha256 "bdbb49a42fd5f0ea6765919adb42ccee7254c482330764d0842eec4e11ad78d7"
  end

  resource "sigstore-models" do
    url "https://files.pythonhosted.org/packages/c6/ed/5c0ff809f90b19f4e971e17c1ed11f4df60082c6010b32a82054087e91e0/sigstore_models-0.0.6.tar.gz"
    sha256 "c766c09470c2a7e8a4a333c893f07e2001c56a3ff1757b1a246119f53169a849"
  end

  resource "sigstore-rekor-types" do
    url "https://files.pythonhosted.org/packages/b4/54/102e772445c5e849b826fbdcd44eb9ad7b3d10fda17b08964658ec7027dc/sigstore_rekor_types-0.0.18.tar.gz"
    sha256 "19aef25433218ebf9975a1e8b523cc84aaf3cd395ad39a30523b083ea7917ec5"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "tuf" do
    url "https://files.pythonhosted.org/packages/25/b5/377a566dfa8286b2ca27ddbc792ab1645de0b6c65dd5bf03027b3bf8cc8f/tuf-6.0.0.tar.gz"
    sha256 "9eed0f7888c5fff45dc62164ff243a05d47fb8a3208035eb268974287e0aee8d"
  end

  resource "typing-inspect" do
    url "https://files.pythonhosted.org/packages/dc/74/1789779d91f1961fa9438e9a8710cdae6bd138c80d7303996933d117264a/typing_inspect-0.9.0.tar.gz"
    sha256 "b23fc42ff6f6ef6954e4852c1fb512cdd18dbea03134f91f856a95ccc9461f78"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)

    generate_completions_from_executable(bin/"ggshield", shell_parameter_format: :click)

    # FIXME: try building app from source. Currently removing as it is pre-built app. Also lacks arm64 support
    rm_r libexec/Language::Python.site_packages("python3.14")/"notifypy/os_notifiers/binaries" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggshield --version")

    ENV["GITGUARDIAN_API_KEY"] = "test"
    output = shell_output("#{bin}/ggshield api-status")
    assert_match "unhealthy (Invalid API key.)", output
  end
end
