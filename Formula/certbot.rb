class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://github.com/certbot/certbot/archive/v0.37.1.tar.gz"
  sha256 "db59585195929ca6af03dfee5ecc9b12bcac2bd42f9ed50c8de5a5165e1258e3"
  revision 2
  head "https://github.com/certbot/certbot.git"

  bottle do
    cellar :any
    sha256 "ba1f8411ff670c32b98e5498643a56480194c71dfbdf6830355f279d4693a099" => :catalina
    sha256 "4273bf106ee6158a2f0d9577c440f51babf44fc85116fa2e1dc8538bd599727c" => :mojave
    sha256 "6f10447ba63bbd5b0d5e28f15975db60ee96db58e32d4334c510faa07479d880" => :high_sierra
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl@1.1"
  depends_on "python"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/c1/a9/86bfedaf41ca590747b4c9075bc470d0b2ec44fb5db5d378bc61447b3b6b/asn1crypto-1.2.0.tar.gz"
    sha256 "87620880a477123e01177a1f73d0f327210b43a3cdbd714efcd2fa49a8d7b384"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/67/5d0548226bcc34468e23a0333978f0e23d28d0b3f0c71a151aef9c3f7680/certifi-2019.6.16.tar.gz"
    sha256 "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/55/ea/f0ade52790bcd687127a302b26c1663bf2e0f23210d5281dbfcd1dfcda28/ConfigArgParse-0.14.0.tar.gz"
    sha256 "2e2efe2be3f90577aca9415e32cb629aa2ecd92078adbe27b53a03e53ff12e91"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/c2/95/f43d02315f4ec074219c6e3124a87eba1d2d12196c2767fadfdc07a83884/cryptography-2.7.tar.gz"
    sha256 "e6347742ac8f35ded4a46ff835c60e68c22a536a8ae5c4422966d06946b6d4c6"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz"
    sha256 "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/a4/78/297f71aafb7d4d825af43087ccf7b4a790283329b246e66d8a31b0cac093/josepy-1.2.0.tar.gz"
    sha256 "9cec9a839fe9520f0420e4f38e7219525daccce4813296627436fe444cd002d3"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/2e/ab/4fe657d78b270aa6a32f027849513b829b41b0f28d9d8d7f8c3d29ea559a/mock-3.0.5.tar.gz"
    sha256 "83657d894c90d5681d62155c82bda9c1187827525880eda8ff5df4ec813437c3"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/81/80/1df9176f9021c588155d0c7a86f1e963cec77fefa31934bc380acb0dbd5e/pbr-5.4.2.tar.gz"
    sha256 "9b321c204a88d8ab5082699469f52cc94c5da45c51f114113d01b3d993c24cdf"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz"
    sha256 "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/7e/24/eaa8d7003aee23eda270099eeec754d7bf4399f75c6a011ef948304f66a2/pyparsing-2.4.2.tar.gz"
    sha256 "6f98a7b9397e206d78cc01df10131398f1c8b8510a2f4d97d9abd82e1aacdd80"
  end

  resource "pyRFC3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/b4/d7/62d335d9df28e2f78207dcd12bbbcee89a7b5ba6d247feaddc9d04f27e1e/python-augeas-1.0.3.tar.gz"
    sha256 "d062f4a44aee797aa9296f5a82cd8c3df5036ca23df6b9ac48cbaa3b4f29a664"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/27/c0/fbd352ca76050952a03db776d241959d5a2ee1abddfeb9e2a53fdb489be4/pytz-2019.2.tar.gz"
    sha256 "26c0b32e437e54a18161324a2fca3c4b9846b74a8dccddd843113109e1116b32"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"
    sha256 "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
  end

  resource "zope.component" do
    url "https://files.pythonhosted.org/packages/49/72/69a2b1eea2b37077e24fa84d287382550c649ecd0b1f25122f4d591ba468/zope.component-4.5.tar.gz"
    sha256 "6edfd626c3b593b72895a8cfcf79bff41f4619194ce996a85bce31ac02b94e55"
  end

  resource "zope.deferredimport" do
    url "https://files.pythonhosted.org/packages/b9/74/6eb2dcf013fac35d086abef2435b5a6621435c2b0c166ef5b63a1b51e91d/zope.deferredimport-4.3.1.tar.gz"
    sha256 "57b2345e7b5eef47efcd4f634ff16c93e4265de3dcf325afc7315ade48d909e1"
  end

  resource "zope.deprecation" do
    url "https://files.pythonhosted.org/packages/34/da/46e92d32d545dd067b9436279d84c339e8b16de2ca393d7b892bc1e1e9fd/zope.deprecation-4.4.0.tar.gz"
    sha256 "0d453338f04bacf91bbfba545d8bcdf529aa829e67b705eac8c1a7fdce66e2df"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/4c/b2/51c0369adcf5be2334280eed230192ab3b03f81f8efda9ddea6f65cc7b32/zope.event-4.4.tar.gz"
    sha256 "69c27debad9bdacd9ce9b735dad382142281ac770c4a432b533d6d65c4614bcf"
  end

  resource "zope.hookable" do
    url "https://files.pythonhosted.org/packages/41/b5/378175b959565de41f45c775cdfbf8897aaeaf29a258b94e40bd2661ce46/zope.hookable-4.2.0.tar.gz"
    sha256 "c1df3929a3666fc5a0c80d60a0c1e6f6ef97c7f6ed2f1b7cf49f3e6f3d4dde15"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/4e/d0/c9d16bd5b38de44a20c6dc5d5ed80a49626fafcb3db9f9efdc2a19026db6/zope.interface-4.6.0.tar.gz"
    sha256 "1b3d0dcabc7c90b470e59e38a9acaa361be43b3a6ea644c0063951964717f0e5"
  end

  resource "zope.proxy" do
    url "https://files.pythonhosted.org/packages/a3/7b/ada37e2c9ba5ba6b23ef8b0f090fd08fabd06e15450c41dca4799349a2dd/zope.proxy-4.3.2.tar.gz"
    sha256 "ab6d6975d9c51c13cac828ff03168de21fb562b0664c59bcdc4a4b10f39a5b17"
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
