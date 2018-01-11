class DcosCli < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform command-line utility to manage DC/OS clusters"
  homepage "https://dcos.io/docs/latest/cli/"
  url "https://github.com/dcos/dcos-cli/archive/0.5.7.tar.gz"
  sha256 "437f5bdbf1be1f3e105c5df98e0423364fd01501115bd7b823122e30252a553d"
  revision 1
  head "https://github.com/dcos/dcos-cli.git"

  bottle do
    cellar :any
    sha256 "82b2f44f6a94a96e1a0d95f462912224c503af4b22a75a973b52b1c28b5976fd" => :high_sierra
    sha256 "033e33592f5ec16bf1b3b8cab4b03881e0fe43b3ff479a50a98ce1f8e220c048" => :sierra
    sha256 "8fcbdcbe67bab924d685924e85723751a74bea66915395f7d556f9215610d758" => :el_capitan
  end

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

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/0a/23/ffee389a45f752dc745706cdb2d354b91ddb71594506fac45236cf67af49/cryptography-2.0.2.tar.gz"
    sha256 "3780b2663ee7ebb37cb83263326e3cd7f8b2ea439c448539d4b87de12c8d06ab"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "pager" do
    url "https://files.pythonhosted.org/packages/5f/a1/95f8605e50c0ccc85ae53f63f5c4cb83b72f71fbd049a0e8259913e2cc22/pager-3.3.tar.gz"
    sha256 "18aa45ec877dca732e599531c7b3b0b22ed6a4445febdf1bdf7da2761cca340d"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/a9/52/f6f41c68625a79bc037d8d75b5a5aa5f525ce2831152be81b5fdb5150175/pkginfo-1.2.1.tar.gz"
    sha256 "ad3f6dfe8a831f96a7b56a588ca874137ca102cc6b79fc9b0a1c3b7ab7320f3c"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/8f/10/9ce7e91d8ec9d852db6f9f2b076811d9f51ed7b0360602432d95e6ea4feb/PyJWT-1.4.2.tar.gz"
    sha256 "87a831b7a3bfa8351511961469ed0462a769724d4da48a501cb8c96d1e17f570"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "sseclient" do
    url "https://files.pythonhosted.org/packages/01/b2/58df4fcd9fa6c70ed4c19a09841227378d78388687cd461926de3cb4743d/sseclient-0.0.14.tar.gz"
    sha256 "fb07aeb662033cc5924d66455cb4aa77e9660eec340eaeb801ddeefa032fbda8"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/af/06/edd820aa8a04ba82354a841af00aa28dcde391a7759a1e34579bb33d63bf/toml-0.9.3.1.tar.gz"
    sha256 "e1e8c220046889234df5ec688d6f97b734fc4a08a6d8edfc176f4e6abf90cfb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install [buildpath, buildpath/"cli"]
    bin.install_symlink libexec/"bin/dcos"
  end

  test do
    assert_match "dcoscli.version=", shell_output("#{bin}/dcos --version")
    assert_match "dcos \[options\] \[\<command\>\] \[\<args\>...\]", shell_output("#{bin}/dcos --help")
  end
end
