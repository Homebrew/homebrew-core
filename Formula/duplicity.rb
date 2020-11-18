class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https://launchpad.net/duplicity"
  url "https://code.launchpad.net/duplicity/0.8-series/0.8.17/+download/duplicity-0.8.17.tar.gz"
  sha256 "a273b1e74d8d0b7825572f51be9c8284e579961e01f4fc1473048e95dce49984"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "1ebf1636babc313593ae85755258fcbdeb23e9e29f972bdae9cc123498b2e0c5" => :big_sur
    sha256 "163f9614457106ff474c57327f314d4c02a70c4707146d17b1f3840b347cb6f1" => :catalina
    sha256 "45ce06149045162a9921737d574b872643f12b464569e6dd69e06fcc1301802b" => :mojave
    sha256 "675ad0408180047202c3f9ca0e77f210459cfae9319967030275f67110b6fa13" => :high_sierra
  end

  depends_on "gnupg"
  depends_on "librsync"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  # Generated with homebrew-pypi-poet from:
  # poet -r fasteners --also future --also mock --also requests --also urllib3 \
  #   --also paramiko --also b2sdk --also boto --also boto3 --also dropbox \
  #   --also pydrive --also requests-oauthlib --also pexpect > resources

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/ec/74/1cf2d9912921cebdba3fa954949206c8aa159c9cc803b88140fb227f8a0e/arrow-0.17.0.tar.gz"
    sha256 "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/50/4c/2e00d4f1e45692f66132c539edb3f9f3fc0a8938c6d49c151d1f72bb6fc2/b2sdk-1.2.0.tar.gz"
    sha256 "8e46ff9d47a9b90d8b9beab1969fcf4920300b02e20e6bf0745be04e09e8a6ff"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1a/ec/b970ae04958b51dab82b848ede21bbf98ef927a158aa968f6d082f18bd6c/boto3-1.16.20.tar.gz"
    sha256 "6c5d952f97e13997b1c7463038d96469355595cd37f87b43451759cc03756322"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/63/64/83904cc34441fc59d493923a6a9595a87a58c40ae36e25cd447ce6b83cee/botocore-1.19.20.tar.gz"
    sha256 "00a69a507e8b817d0703c612131e6cb3a3260579d0353c56d005bd9effd92ec0"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/fc/c8/0b52cf3132b4b85c9e83faa3e4d375575afeb3a1710c40b2b2cd2a3e5635/cachetools-4.1.1.tar.gz"
    sha256 "bbaa39c3dede00175df2dc2b03d0cf18dd2d32a7de7beb68072d13043c9edb20"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/de/879cf857ae6f890dfa23c3d6239814c5471936b618c8fb0c8732ad5da885/certifi-2020.11.8.tar.gz"
    sha256 "f05def092c44fbf25834a51509ef6e631dc19765ab8a57b4e7ab85531f0a9cf4"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/cb/ae/380e33d621ae301770358eb11a896a34c34f30db188847a561e8e39ee866/cffi-1.14.3.tar.gz"
    sha256 "f92f789e4f9241cd262ad7a555ca2c648a98178a953af117ef7fad46aa1d5591"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/94/5c/42de91c7fbdb817b2d9a4e64b067946eb38a4eb36c1a09c96c87a0f86a82/cryptography-3.2.1.tar.gz"
    sha256 "d3d5e10be0cf2a12214ddee45c6bd203dab435e3d83b4560c03066eda600bfe3"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/49/18/bfdcac85c16e7b31fe8087fabee6820657e48a1514c249aae093f109ac09/dropbox-10.10.0.tar.gz"
    sha256 "df43e9e0bdcae6d610dd754a5ec72f2f91a311bbc2c8a28d076df69695b18398"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/15/d7/1e8b3270f21dffcaaf5a2889675e8b2fa35f8a43a5817a31d3820e8e9495/fasteners-0.15.tar.gz"
    sha256 "3a176da6b70df9bb88498e1a18a9e4a8579ed5b9141207762368a1017bf8f5ef"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/9a/a1/db866879d86b04f1c0eb777472eefd8756268d5be14d09c31331d56fb37a/google-api-python-client-1.12.6.tar.gz"
    sha256 "1f5cfcb92c8e3bd0a69cb2ff3cefa5ff16ffa1900af795a53f5bed93c8238951"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/65/1c/eee2dbfefe37855300e4f89245c698bb1713de215d191a5127317b418576/google-auth-1.23.0.tar.gz"
    sha256 "5176db85f1e7e837a646cd9cede72c3c404ccf2e3373d9ee14b2db88febad440"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/6c/5e/97a5e7573457020351a275c74c559dbe2ebe1c606119f991541c98ffa651/google-auth-httplib2-0.0.4.tar.gz"
    sha256 "8d092cc60fb16517b12057ec0bba9185a96e3b7169d86ae12eae98e645b7bc39"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/98/3f/0769a851fbb0ecc458260055da67d550d3015ebe6b8b861c79ad00147bb9/httplib2-0.18.1.tar.gz"
    sha256 "8af66c1c52c7ffe1aa5dc4bcd7c769885254b0756e6e69f953c7f0ab49a70ba3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/e2/a0/66a7b78e1800af85e54701490cf8764cc6de6c0725d18b10a6fb13ce4d2d/logfury-0.1.2.tar.gz"
    sha256 "42da58fbbd4e6fdb9e5b6b9098e94c249ba9cebfae125643329c8636768edcd3"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/2e/35/594f501b2a0fb3732c8190ca885dfdf60af72d678cd5fa8169c358717567/mock-4.0.2.tar.gz"
    sha256 "dd33eb70232b6118298d516bbcecd26704689c386594f0f3c4f13867b2c56f72"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz"
    sha256 "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyDrive" do
    url "https://files.pythonhosted.org/packages/52/e0/0e64788e5dd58ce2d6934549676243dc69d982f198524be9b99e9c2a4fd5/PyDrive-1.3.1.tar.gz"
    sha256 "83890dcc2278081c6e3f6a8da1f8083e25de0bcc8eb7c91374908c5549a20787"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9f/14/4a6542a078773957aa83101336375c9597e6fe5889d20abda9c38f9f3ff2/requests-2.25.0.tar.gz"
    sha256 "7f1a0b932f4a60a1a65caa4263921bb7d9ee911957e0ae4a23a6dd08185ad5f8"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/a2/d5/04b8a9719149583fec76efdff2e7a81c6e3cc34909ee818d3fbf115edc2e/rsa-4.6.tar.gz"
    sha256 "109ea5a66744dd859bf16fe904b8d8b627adafb9408753161e766a92e7d681fa"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "setuptools_scm" do
    url "https://files.pythonhosted.org/packages/cd/66/fa77e809b7cb1c2e14b48c7fc8a8cd657a27f4f9abb848df0c967b6e4e11/setuptools_scm-4.1.2.tar.gz"
    sha256 "a8994582e716ec690f33fec70cca0f85bd23ec974e3f783233e4879090a7faa8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/9f/30/8c8015735a54e13444a3d4982a7a9538bde27f8b3bd35203f9e920f0d78c/tqdm-4.52.0.tar.gz"
    sha256 "18d6a615aedd09ec8456d9524489dab330af4bd5c2a14a76eb3f9a0e14471afe"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/05/d9/6eebe19d46bd05360c9a9aae822e67a80f9242aabbfc58b641b957546607/typing-3.7.4.3.tar.gz"
    sha256 "1187fb9c82fd670d10aa07bbb6cfcfe4bdda42d6fab8d5134f04e8c4d0b71cc9"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  def install
    virtualenv_install_with_resources
    inreplace Dir[bin/"*"], %r{^#!/usr/bin/env python.*$},
                            "#!#{libexec}/bin/python"
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
    begin
      (testpath/"test/hello.txt").write "Hello!"
      (testpath/"command.sh").write <<~EOS
        #!/bin/sh
        ulimit -n 1024
        PASSPHRASE=brew #{bin}/duplicity #{testpath} "file://test"
      EOS
      chmod 0555, testpath/"command.sh"
      system "./command.sh"
      assert_match "duplicity-full-signatures", Dir["test/*"].to_s

      # Ensure requests[security] is activated
      script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
      system libexec/"bin/python", "-c", script
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
