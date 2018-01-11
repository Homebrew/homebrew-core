class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v0.20.0.tar.gz"
  sha256 "3a0ae2ebb82e580d8e9849d4a9a8e876a907be26fe2db2bc075fd887826c71b2"
  revision 1
  head "https://github.com/certbot/certbot.git"

  bottle do
    cellar :any
    sha256 "8875ee8b5eadfabf7af762a8fe55cc4b7be683572dd174d75bda47f455bfeb31" => :high_sierra
    sha256 "be888dccd9560b0729b56aac0b9ee56aafe4fbcc76db117ab08701de21e5afe4" => :sierra
    sha256 "0c4424d3b285daaf68f3431701a7f0d90c511a1730a65d9c377a3d07e66b0c70" => :el_capitan
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl"
  depends_on "python3"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/17/8d/4a41f11b0971017c7001f118be8003da8f7b96b010c66cd792b76658d1e1/ConfigArgParse-0.12.0.tar.gz"
    sha256 "28cd7d67669651f2a4518367838c49539457504584a139709b2b8f6c208ef339"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/78/c5/7188f15a92413096c93053d5304718e1f6ba88b818357d05d19250ebff85/cryptography-2.1.4.tar.gz"
    sha256 "e4d967371c5b6b2e67855066471d844c5d52d210c36c28d49a8507b96e2c5291"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/3b/15/a5d90ab1a41075e8f0fae334f13452549528f82142b3b9d0c9d86ab7178c/pyOpenSSL-17.5.0.tar.gz"
    sha256 "2c10cfba46a52c0b0950118981d61e72c1e5b1aac451ca1bc77de1a679456773"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/7a/8a/78e04792f04da5f3780058f8cfc35ff9eb74080faffbf321c58e6d34d089/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"
    sha256 "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "zope.component" do
    url "https://files.pythonhosted.org/packages/45/3c/bd34f228e2ff303071b5ff68657abf6d11af2151056acd449796eff694e0/zope.component-4.4.1.tar.gz"
    sha256 "1b29aa65413f6dda29e64e2352a6aa13d9ba70078f6b91f328573488788d531c"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/9e/d0/54ba59f19a0635f6591b74be259cf6fbf67e73f4edda27b5cd0cf4d26efa/zope.event-4.3.0.tar.gz"
    sha256 "e0ecea24247a837c71c106b0341a7a997e3653da820d21ef6c08b32548f733e7"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/bd/d2/25349ed41f9dcff7b3baf87bd88a4c82396cf6e02f1f42bb68657a3132af/zope.interface-4.4.3.tar.gz"
    sha256 "d6d26d5dfbfd60c65152938fcb82f949e8dada37c041f72916fef6621ba5c5ce"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/b4/d7/62d335d9df28e2f78207dcd12bbbcee89a7b5ba6d247feaddc9d04f27e1e/python-augeas-1.0.3.tar.gz"
    sha256 "d062f4a44aee797aa9296f5a82cd8c3df5036ca23df6b9ac48cbaa3b4f29a664"
  end

  def install
    venv = virtualenv_install_with_resources

    # Shipped with certbot, not external resources.
    %w[acme certbot-apache certbot-nginx].each do |r|
      venv.pip_install buildpath/r
    end
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
