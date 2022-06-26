class Gcalcli < Formula
  include Language::Python::Virtualenv

  desc "Easily access your Google Calendar(s) from a command-line"
  homepage "https://github.com/insanum/gcalcli"
  url "https://files.pythonhosted.org/packages/e8/d9/9d1f03b9b47c3082bf664a2f789a3aded0674dca9e0b894540d754b937cc/gcalcli-4.3.0.tar.gz"
  sha256 "d00081460276027196e8fb957880b29ba4f22ea43136f9e232a9408016abc110"
  license "MIT"
  revision 2
  head "https://github.com/insanum/gcalcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25e29788f501cab37b55b8d5b91c44c1c2fb4cf24a0c8d419f81a3991e763b83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23844c10c996a9799ddd4437d7a9ae444a979f09ecc943a233a7131069065b51"
    sha256 cellar: :any_skip_relocation, monterey:       "6051d8fa707025a470ca489394089fabf6184bb1fa079fa2a5d7a96352cdcc81"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb8ada7ea2311c450b7d63fd95f18b75b71041e0dfae61726f263a3c4a464233"
    sha256 cellar: :any_skip_relocation, catalina:       "4d49124119eaa88faf4e531d3fb0ddcf1dab4746bae9af433ff700c390601e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4806f6dedd7ad1e68acea930671f247ee1729dbe001638ef0c07148529475b0"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/ad/81/539036a8716b4e0a96f77540194bb1e863a24b8e9bc9ddd74e30f1653df5/cachetools-5.0.0.tar.gz"
    sha256 "486471dfa8799eb7ec503a8059e263db000cdda20075ce5e48903087f79d5fd6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/7b/16/919e6c52a6dd601ac45871b1b674edcfab4138cbbed753af242ea4c25c7a/google-api-core-2.7.3.tar.gz"
    sha256 "17957f0704cbe95bd2ce25019efd2046423978594d181d4263e5dcffd2dbbc79"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/0c/b9/cb565767e965e65d8ea74525ca7c94ba880dad1664343ecf93f524bc22df/google-api-python-client-2.47.0.tar.gz"
    sha256 "b5201be41304b730e697824d84b24d3a404bd4b9b0fd3e94dcd30599fd642641"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/fd/8c/3c24a436775d6582effe4ecaf33b2562e6a7f0cbc647a293c764c5eac9ee/google-auth-2.6.6.tar.gz"
    sha256 "1ba4938e032b73deb51e59c4656a00e0939cf0b1112575099f136babb4563312"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/dc/11/52169cc0f9a94ab6eb0873ae441bd8c58e5a757240faef973e04b6503816/googleapis-common-protos-1.56.0.tar.gz"
    sha256 "4007500795bcfc269d279f0f7d253ae18d6dc1ff5d5a73613ffe452038b1ec5f"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/9c/65/57ad964eb8d45cc3d1316ce5ada2632f74e35863a0e57a52398416a182a1/httplib2-0.20.4.tar.gz"
    sha256 "58a98e45b4b1a48273073f905d2961666ecf0fbac4250ea5b47aef259eb5c585"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/96/1283259c25bc48a6df98fa096f66fc568b40137b93806ef5ff66a2d166b1/protobuf-3.20.1.tar.gz"
    sha256 "adc31566d027f45efe3f44eeb5b1f329da43891634d61c75a5944e9be6dd42c9"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/31/df/789bd0556e65cf931a5b87b603fcf02f79ff04d5379f3063588faaf9c1e4/pyparsing-3.0.8.tar.gz"
    sha256 "7bf433498c016c4314268d95df76c81b842a4cb2b276fa3312cfb1e1d85f6954"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/8c/ee/4022542e0fed77dd6ddade38e1e4dea3299f873b7fd4e6d78319953b0f83/rsa-4.8.tar.gz"
    sha256 "5c6bd9dc7a543b7fe4304a631f8a8a3b674e2bbfc49c2ae96200cdbe55df6b17"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/gcalcli --client-id=foo --client-secret=bar --noauth_local_webserver list", "foo")
    assert_match "Go to the following link in your browser:", output
  end
end
