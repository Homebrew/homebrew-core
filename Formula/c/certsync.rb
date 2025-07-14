class Certsync < Formula
  include Language::Python::Virtualenv

  desc "Dump NTDS with golden certificates and UnPAC the hash"
  homepage "https://github.com/zblurx/certsync"
  url "https://files.pythonhosted.org/packages/c8/75/3928920bdbfb0af317446236fad17b47a1d6aad507f1ae2eed6bbf7e7ad9/certsync-0.1.6.tar.gz"
  sha256 "bbfffd10f36edcb8c4d2d5033f2a2e1e7d641e41d6c5bd11069e7b0827fa1c8d"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce9f96e07b826ca7f88e7324e519c77895a8067fb7a515467b01b8d340e11916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32fc1c809f36a9d0e28157ccf6d00ca9e42deaec653b5da3234daa3eed3add44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "555abc7e5f9f99cce2a30ee4bdc16f026e88e671493031d131bb927c91aa7f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "532555d93a5da39106b2f604aa15d2a1747b145c5a536ef2eefbd5581c37e586"
    sha256 cellar: :any_skip_relocation, ventura:       "998bf723887fe7f207080371812376b60fce993cfbd1f3c2385dd46f246010f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8acb4485616f556af6d01c12d11e0d4ba99cc1fc50d5419d31a0745fb7dfe38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424a8c8dda9bf9297d5b125aa9ab017bf299c695b8d03836d1109042251fd658"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "certipy-ad" do
    url "https://files.pythonhosted.org/packages/ff/fd/349505ced12b137fc05c174fde5b798fcefa032dfbd8bf70549a65598e42/certipy-ad-4.8.2.tar.gz"
    sha256 "03aa7e898eff2946c32494f82c2f156afbbc966fd157e599780ab19d638eaf50"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b5/4a/263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829/dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "dsinternals" do
    url "https://files.pythonhosted.org/packages/ef/e4/2ceffa1b0e1751e3470deaa4512f22d46b8e51ec2227c679b73dbe4165e5/dsinternals-1.2.4.tar.gz"
    sha256 "030f935a70583845f68d6cfc5a22be6ce3300907788ba74faba50d6df859e91d"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/c0/de/e47735752347f4128bcf354e0da07ef311a78244eba9e3dc1d4a5ab21a98/flask-3.1.1.tar.gz"
    sha256 "284c7b8f2f58cb737f0cf1c30fd7eaf0ccfcde196099d24ecede3fc2005aa59e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "impacket" do
    url "https://files.pythonhosted.org/packages/5f/da/248137b069d292d4ff019c39015356f3b4eb52a08dc77397ff0fbe5166d0/impacket-0.12.0.tar.gz"
    sha256 "89587d1b836a5220d74848c934757962b382886dca8b1b4a0c44d693f2600643"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/43/ac/96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0/ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "ldapdomaindump" do
    url "https://files.pythonhosted.org/packages/14/48/2757e0453f828e33f7b41e5489976fbe7d504d513e07da53eb904030a288/ldapdomaindump-0.10.0.tar.gz"
    sha256 "cbc66b32a7787473ffd169c5319acde46c02fdc9d444556e6448e0def91d3299"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "pyspnego" do
    url "https://files.pythonhosted.org/packages/6b/f8/53f1fc851dab776a183ffc9f29ebde244fbb467f5237f3ea809519fc4b2e/pyspnego-0.11.2.tar.gz"
    sha256 "994388d308fb06e4498365ce78d222bf4f3570b6df4ec95738431f61510c971b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-ntlm" do
    url "https://files.pythonhosted.org/packages/15/74/5d4e1815107e9d78c44c3ad04740b00efd1189e5a9ec11e5275b60864e54/requests_ntlm-1.3.0.tar.gz"
    sha256 "b29cc2462623dffdf9b88c43e180ccb735b4007228a542220e882c58ae56c668"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  # pypi artifact request, https://github.com/skelsec/unicrypto/issues/7
  resource "unicrypto" do
    url "https://github.com/skelsec/unicrypto/archive/refs/tags/0.0.10.tar.gz"
    sha256 "3daefcdf8e71f9300032393ad85d7f22fc08d07dc05cf7776019b9480bd8506a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/certsync -randomize -dc-ip localhost 2>&1")
    assert_match "Got error: nameserver localhost is not a dns.nameserver.Nameserver", output

    assert_match "Dump NTDS with golden certificates", shell_output("#{bin}/certsync -h")
  end
end
