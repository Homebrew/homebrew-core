class Gyb < Formula
  include Language::Python::Virtualenv
  desc "CLI for backing up and restoring Gmail messages"
  homepage "https://github.com/GAM-team/got-your-back/"
  url "https://github.com/GAM-team/got-your-back/archive/v1.73.tar.gz"
  sha256 "a8c521325a96907916dfc6d24651312c8abe57215b084a94635165c7052ed76d"
  license "Apache-2.0"
  head "https://github.com/GAM-team/got-your-back.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "602d9dfce6755f7e3fe3803dacf3c41c99e8b2ed0a5e1b16c1a3f5eda37dc578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbaab2fa74f08eb34d67ae5d3b6534aa8e511b6f178d92e4f5702ac76c564d0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01fb5b6feb46a3c13b87738534467002388044754330e70fea41704119d120d7"
    sha256 cellar: :any_skip_relocation, ventura:        "2579e77951d64ee85a8d4ff0212af2c4bc4e8da98aa922d20c49b09e6294d464"
    sha256 cellar: :any_skip_relocation, monterey:       "5eaac37d23f9934c9c09c81a195a293ecff8a39c434215a6da88ca1ae55b7678"
    sha256 cellar: :any_skip_relocation, big_sur:        "702ea65eecb4ea9b4eaaf3d00ad9cc0b49bf83f5e0605702937c519e5dde4917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d4f7ef20416aa2c86dc62b727f35cac6c9185416eff75bffa806de8e1100dc8"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.11"
  depends_on "six"

  # direct dependencies
  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c2/37/a093aaa902f6b2301f0f2cff5285548dbc4ab9b9a29215eb440381cbb32b/httplib2-0.21.0.tar.gz"
    sha256 "fc144f091c7286b82bec71bdbd9b27323ba709cc612568d3000893bfd9cb4b34"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/4a/af/6e9ba1d552043c69bddeb761126fe9c9c0a8e896d35a304785d132571523/google-api-python-client-2.73.0.tar.gz"
    sha256 "7e860e3ec27b504fb797fa23c07c012a874dd736491fddbe50a20d3bdde8ace6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a9/b8/106bf395ad5be94bfd1e4c157a36db6dfcca445f72ff63458358d9203157/google-auth-2.16.0.tar.gz"
    sha256 "ed7057a101af1146f0554a769930ac9de506aeca4fd5af6543ebe791851a9fbd"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/06/98/52a79d64ca8fd2e37eff8da6c78c26b2209f19d8ace8cafd1634453c4393/google-auth-oauthlib-0.8.0.tar.gz"
    sha256 "81056a310fb1c4a3e5a7e1a443e1eb96593c6bbc55b26c0261e4d3295d3e6593"
  end

  # sub-dependencies
  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/2b/15/7bafa5379a228ed72baf769eea5e6019a944469fe637ea0742c0351109bf/google-api-core-2.11.0.tar.gz"
    sha256 "4b9bb5d5a380a0befa0573b302651b8a9a89262c1730e37bf423cec511804c22"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/c5/db/9b98c3a9e148b5daaa2e26ce4faeb6ade28dc623dcc109f2ac7efee514de/googleapis-common-protos-1.57.0.tar.gz"
    sha256 "27a849d6205838fb6cc3c1c21cb9800707a661bb21c6ce7fb13e99eb1f8a0c46"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz"
    sha256 "2e3427429c9cffebf259491be0af70189607f365c2f41c7c3764af6f337105f2"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/eb/3d/b7d0fdf4a882e26674c68c20f40682491377c4db1439870f5b6f862f76ed/pyasn1-0.4.2.tar.gz"
    sha256 "d258b0a71994f7770599835249cece1caef3c70def868c4915e6e5ca49b67d15"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/ab/76/36ab0e099e6bd27ed95b70c2c86c326d3affa59b9b535c63a2f892ac9f45/pyasn1-modules-0.2.1.tar.gz"
    sha256 "af00ea8f2022b6287dc375b2c70f31ab5af83989fc6fe9eacd4976ce26cd7ccc"
  end

  resource "pyinstaller" do
    url "https://files.pythonhosted.org/packages/13/2e/bc4c0026659cea46aca867f4d71e8bab5a6430b4c005c51e174da5e6e4a2/pyinstaller-5.7.0.tar.gz"
    sha256 "0e5953937d35f0b37543cc6915dacaf3239bcbdf3fd3ecbb7866645468a16775"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/70/ca/a8c03acf2f249a3675cac6a322e70fa4ea200f40590cf72cb4cd322bfeb3/pyinstaller-hooks-contrib-2022.15.tar.gz"
    sha256 "73fd4051dc1620f3ae9643291cd9e2f47bfed582ade2eb05e3247ecab4a4f5f3"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/de/a2/f55312dfe2f7a344d0d4044fdfae12ac8a24169dc668bd55f72b27090c32/requests-oauthlib-1.2.0.tar.gz"
    sha256 "bd6533330e8748e94bf0b214775fed487d309b8b8fe823dc45641ebcd9a32f57"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    print buildpath
    # change user config location from default of executable own path
    inreplace "gyb.py", "default=getProgPath()",
                        "default='#{pkgetc}'"
    venv = virtualenv_create(buildpath, "python3")
    venv.pip_install resources
    system buildpath/"bin/python3", "-m", "PyInstaller", "gyb.spec"
    bin.install "dist/gyb"
  end

  def post_install
    pkgetc.mkpath
  end

  def caveats
    <<~EOS
      Default config_folder: #{pkgetc}
    EOS
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/gyb --version 2>&1")
    # Below throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "ERROR: --email is required.", shell_output("#{bin}/gyb", 1)
  end
end
