class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https://launchpad.net/duplicity"
  url "https://launchpad.net/duplicity/0.8-series/0.8.09/+download/duplicity-0.8.09.tar.gz"
  sha256 "4e10c6fa5cc02592c9fe1f318b27b66242a2e74c03c2149b9b9b9365acebd105"

  bottle do
    cellar :any
    sha256 "6005d6d49078a2931f52a8c9d0a0b8f783ab49fd7f3deed2a935958686da589a" => :catalina
    sha256 "ce07220381fffd14c37749c4f44760a4e60d9fe3d576f01f05260d00474a5c3c" => :mojave
    sha256 "bf9e84145ce1870c62de83025263fee17e8f3cefcca33a5766100e81c0c44642" => :high_sierra
  end

  depends_on "gnupg"
  depends_on "librsync"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  # Generated with homebrew-pypi-poet from:
  # poet -r fasteners --also future --also mock --also requests --also urllib3 \
  #   --also paramiko --also b2sdk --also boto --also boto3 --also dropbox \
  #   --also pydrive --also requests-oauthlib --also pexpect > resources

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/5d/c7/468bb95a10fb8ddb5f3f80e1aef06b78f64d6e5df958c39672f80581381f/arrow-0.13.0.tar.gz"
    sha256 "9cb4a910256ed536751cd5728673bfb53e6f0026e240466f90c2a92c0b79c895"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/ea/2e/bd06b7250d936b8cf502d44c789e90cb4837dd9c9242ed88e9a2bc30bb05/b2sdk-0.1.8.tar.gz"
    sha256 "91bcf09a05f5e822f7494824bf2fd75a81ff0035d2670f443a6f89454d18ab31"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/fa/aa/025a3ab62469b5167bc397837c9ffc486c42a97ef12ceaa6699d8f5a5416/bcrypt-3.1.7.tar.gz"
    sha256 "0b0069c752ec14172c5f78208f1863d7ad6755a6fae6fe76ec2c80d13be41e42"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a5/8f/d274941ae26ab53c01529777c03a7040fccfbc6c9a28a9a8212d87bfa920/boto3-1.11.0.tar.gz"
    sha256 "d7a3c425f55e2b1974201f610adbf1963db1c80d9fd58a04963557a09fbf0aed"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1e/ef/2248110e8141b64db4e7795841eae3e25c34546a3981105580a0b2569ab4/botocore-1.14.0.tar.gz"
    sha256 "9980e043842e42251a9d342836d79ee824b0d25f22b0f5e00f2dda57be1090f9"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/ff/e9/879bc23137b5c19f93c2133a6063874b83c8e1912ff1467a3d4331598921/cachetools-4.0.0.tar.gz"
    sha256 "9a52dd97a85f257f4e4127f15818e71a0c7899f121b34591fcc1173ea79a0198"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"
    sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/be/60/da377e1bed002716fb2d5d1d1cab720f298cb33ecff7bf7adea72788e4e4/cryptography-2.8.tar.gz"
    sha256 "3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/1f/7d/6e90b169fe4142b3b2332fd22d2aecfdc971e42eef19ea1c50b2384067f2/dropbox-6.9.0.tar.gz"
    sha256 "db1be6dab980f6819508c9f70d2c82b32aad4b7f5f0c52354fdb48ca4abdee49"
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
    url "https://files.pythonhosted.org/packages/5e/19/9fd511734c0dee8fa3d49f4109c75e7f95d3c31ed76c0e4a93fbba147807/google-api-python-client-1.7.11.tar.gz"
    sha256 "a8a88174f66d92aed7ebbd73744c2c319b4b1ce828e565f9ec721352d2e2fb8c"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/e6/4f/e0b42a9da46a95437ae7517e9c883e886e77cb3f709d2b39ff21fa67251b/google-auth-1.10.0.tar.gz"
    sha256 "7bb2034a3a290190cf4e3eb8ebf29e5025c90f0b06a00ba4d1fb94bf0c6448f7"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/e7/32/ac7f30b742276b4911a1439c5291abab1b797ccfd30bc923c5ad67892b13/google-auth-httplib2-0.0.3.tar.gz"
    sha256 "098fade613c25b4527b2c08fa42d11f3c2037dda8995d86de0745228e965d445"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/4b/fb/6ab4e89de856c023bea8f21acff54324f32fa3e2c8da690f2bffd8e5de5b/httplib2-0.15.0.tar.gz"
    sha256 "a5f914f18f99cb9541660454a159e3b3c63241fc3ab60005bb88d97cc7a4fb58"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/2c/30/f0162d3d83e398c7a3b70c91eef61d409dea205fb4dc2b47d335f429de32/jmespath-0.9.4.tar.gz"
    sha256 "bde2aef6f44302dfb30320115b17d030798de8c4110e28d5cf6cf91a7a31074c"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/e2/a0/66a7b78e1800af85e54701490cf8764cc6de6c0725d18b10a6fb13ce4d2d/logfury-0.1.2.tar.gz"
    sha256 "42da58fbbd4e6fdb9e5b6b9098e94c249ba9cebfae125643329c8636768edcd3"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/2e/ab/4fe657d78b270aa6a32f027849513b829b41b0f28d9d8d7f8c3d29ea559a/mock-3.0.5.tar.gz"
    sha256 "83657d894c90d5681d62155c82bda9c1187827525880eda8ff5df4ec813437c3"
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
    url "https://files.pythonhosted.org/packages/ac/15/4351003352e11300b9f44a13576bff52dcdc6e4a911129c07447bda0a358/paramiko-2.7.1.tar.gz"
    sha256 "920492895db8013f6cc0179293147f830b8c7b21fdfc839b6bad760c27459d9f"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/1c/b1/362a0d4235496cb42c33d1d8732b5e2c607b0129ad5fdd76f5a583b9fcb3/pexpect-4.7.0.tar.gz"
    sha256 "9e2c1fd0e6ee3a49b28f95d4b33bc389c89b20af6a1255906e90ff1262ce62eb"
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
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "PyDrive" do
    url "https://files.pythonhosted.org/packages/52/e0/0e64788e5dd58ce2d6934549676243dc69d982f198524be9b99e9c2a4fd5/PyDrive-1.3.1.tar.gz"
    sha256 "83890dcc2278081c6e3f6a8da1f8083e25de0bcc8eb7c91374908c5549a20787"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/cb/d0/8f99b91432a60ca4b1cd478fd0bdf28c1901c58e3a9f14f4ba3dba86b57f/rsa-4.0.tar.gz"
    sha256 "1a836406405730121ae9823e19c6e806c62bbad73f890574fff50efa4122c487"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/43/bf/5a0117a8e848aebc8a0cb1f2f62c016ff8eec481568ba6714c48e23a01c1/s3transfer-0.3.0.tar.gz"
    sha256 "e3343ae0f371781c17590cf06cb818a54484fbac9a65a5be7603a39b0a6d7b31"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/cd/22/f15bb3c0a2810da0e825d193fb76d782015d82c676c4f682a957814926d7/tqdm-4.41.1.tar.gz"
    sha256 "4789ccbb6fc122b5a6a85d512e4e41fc5acad77216533a6f2b8ce51e0f265c23"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/67/b0/b2ea2bd67bfb80ea5d12a5baa1d12bda002cab3b6c9b48f7708cd40c34bf/typing-3.7.4.1.tar.gz"
    sha256 "91dfe6f3f706ee8cc32d38edbbf304e9b7583fb37108fef38229617f8b3eba23"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz"
    sha256 "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745"
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
