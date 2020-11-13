class Cloudtoken < Formula
  include Language::Python::Virtualenv

  desc "A command-line utility facilitating steps required to authenticate with public a cloud provider such as AWS"
  homepage "https://bitbucket.org/atlassian/cloudtoken/src/master/"
  url "https://files.pythonhosted.org/packages/2c/09/cf5f71c9a3e2431c42583d543536bb8406376937a0514ed7e02a074a8659/cloudtoken-0.1.685.tar.gz"
  sha256 "9bc5a5cb525ce65cd7634ac986909328cea4c7e5c912221b78ce819d7ab1b8a4"

  depends_on "openssl"
  depends_on "python@3.8"

  resource "cloudtoken-plugin.adfs" do
    url "https://files.pythonhosted.org/packages/60/5a/1d5c8e8f0ec11afce01ca13abb6307b876292f47b742a50cb2ef7e43c4eb/cloudtoken-plugin.adfs-0.1.685.tar.gz"
    sha256 "3cff2c52898716562509c3236cded624ccd8905eda910b1d4110b913c0e6d3d6"
  end

  resource "cloudtoken-plugin.awscli-exporter" do
    url "https://files.pythonhosted.org/packages/51/d9/ebfd2f4d4cd05453bf50edcc355576502406f31806c2fef59ce76ebd684f/cloudtoken-plugin.awscli_exporter-0.1.685.tar.gz"
    sha256 "2f70776e1a97e1a3d176918d6d4f44fda9dfc215cc14120adb28f225fc138bec"
  end

  resource "cloudtoken-plugin.centrify" do
    url "https://files.pythonhosted.org/packages/42/41/a81c1891775655fe73571f4ef91d92d22b26e150e6b33c663588356da096/cloudtoken-plugin.centrify-0.1.685.tar.gz"
    sha256 "aff5d2d552c48333a927680e70c25c896b110de9c10a54df9ac9fd24f0007941"
  end

  resource "cloudtoken-plugin.google-aws" do
    url "https://files.pythonhosted.org/packages/0f/f9/d5d6f0880d4cd08a272777bc6d10bf7b559c16d41997d6aa32d0e54586c6/cloudtoken-plugin.google-aws-0.1.685.tar.gz"
    sha256 "ec9cfbbaa99b081e1e9b512fabb8cbd94a26f0841fde657f4a13dacd0796e0d6"
  end

  resource "cloudtoken-plugin.json-exporter" do
    url "https://files.pythonhosted.org/packages/f2/f5/54c240b059078fdd33b8a68859a3a8f70676e23613f215811d7e86f52e81/cloudtoken-plugin.json_exporter-0.1.685.tar.gz"
    sha256 "2b5364f30b906b918dff659d344cd89279ae450582f5af5b9d9253d6f6f00a1d"
  end

  resource "cloudtoken-plugin.saml" do
    url "https://files.pythonhosted.org/packages/33/0e/1588a00b2934cf396014473410a5cc18d8305927cec17b5057d93f5b0404/cloudtoken-plugin.saml-0.1.685.tar.gz"
    sha256 "d3908d18079899398f90b45ed713ebe419de5bf6bd0e088d7a3a1154008dd398"
  end

  resource "cloudtoken-plugin.shell-exporter" do
    url "https://files.pythonhosted.org/packages/e1/c3/775801969d6c6c4ab81b065251b5b40db84ec8dbeec3919caa6af9db2c9f/cloudtoken-plugin.shell_exporter-0.1.685.tar.gz"
    sha256 "90777871ea4f16fd4569968c2c92f376ce6d1d089d5c4c61bcb8b1e93d57e0eb"
  end

  resource "cloudtoken-plugin.url-generator" do
    url "https://files.pythonhosted.org/packages/ad/40/5c7c5a1d348cd072f7f2fb7bce64b31d739d1c8e0e64f63ae6bad74a45fd/cloudtoken-plugin.url_generator-0.1.685.tar.gz"
    sha256 "1b29d158534d5ab041ef203cad2f85d4755d73bd4f9fcb1628c9fa5432f24106"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/b9/f8/8f49278581cb848fb710a362bfc3028262a82044167684fb64ad068dbf92/ndg_httpsclient-0.5.1.tar.gz"
    sha256 "d72faed0376ab039736c2ba12e30695e2788c4aa569c9c3e3d72131de2592210"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "schedule" do
    url "https://files.pythonhosted.org/packages/00/07/6a9953ff83e003eaadebf0a51d33c6b596f9451fcbea36a3a2e575f6af99/schedule-0.6.0.tar.gz"
    sha256 "f9fb5181283de4db6e701d476dd01b6a3dd81c38462a54991ddbb9d26db857c9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/3e/79/da95ce71b572ce01c268492957cc4c1055da6f683077a6caba10944dc4f2/keyring-21.4.0.tar.gz"
    sha256 "9aeadd006a852b78f4b4ef7c7556c2774d2432bbef8ee538a3e9089ac8b11466"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/fe/ab/bfaa62438cc38f8ca936dd34bb766aad5a6b1dc9c0ba83b0662d623801bb/keyrings.alt-4.0.0.tar.gz"
    sha256 "f70ef01a8f2b968b83643db370a1e85bc0e4bc8b358f9661504279afb019d21d"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/4e/0b/cb02268c90e67545a0e3a37ea1ca3d45de3aca43ceb7dbf1712fb5127d5d/Flask-1.1.2.tar.gz"
    sha256 "4efa1ae2d7c9865af48986de8aeb8504bf32c7f3d6fdc9353d34b21f4b127060"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/3f/e7/9518720c56396179f8c63d7b5924c8463ed423828e54329be7f8cde5c364/configparser-5.0.1.tar.gz"
    sha256 "005c3b102c96f4be9b8f40dafbd4997db003d07d1caa19f37808be8031475f2a"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/6b/94/4663206f709ac32446e995227cc5be34d5e2aa74ba8f92b8083c2740d3d7/pyquery-1.4.1.tar.gz"
    sha256 "8fcf77c72e3d602ce10a0bd4e65f57f0945c18e15627e49130c27172d4939d98"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c5/2f/a0d8aa3eee6d53d5723d89e1fc32eee11e76801b424e30b55c7aa6302b01/lxml-4.6.1.tar.gz"
    sha256 "c152b2e93b639d1f36ec5a8ca24cde4a8eefb2b6b83668fcd8e83a67badcb367"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c2/62/a16554bef40adc732dacbce7b88db85cf508958d952c38a92a789a8a5a0c/boto3-1.16.7.tar.gz"
    sha256 "2cabcdc217a128832d6c948cae22cbd3af03ae0736efcb59749f1f11f528be54"
  end

  resource "python-u2flib-host" do
    url "https://files.pythonhosted.org/packages/4d/3d/0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2/python-u2flib-host-3.0.3.tar.gz"
    sha256 "ab678b9dc29466a779efcaa2f0150dce35059a7d17680fc26057fa599a53fc0a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d7/d7/3d540494414a311a772a6ab27f23bf976fec0ee152c0b5d0bfb62ced6176/botocore-1.19.7.tar.gz"
    sha256 "ab59f842797cbd09ee7d9e3f353bb9546f428853d94db448977dd554320620b3"
  end

  resource "dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/cloudtoken", "--help"
  end
end
