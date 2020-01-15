class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://github.com/elceef/dnstwist/archive/20190706.tar.gz"
  sha256 "d1192a3aca209b537f54274471398ad4cd8b040551eb0469011d0231ee53520a"
  revision 1

  bottle do
    cellar :any
    sha256 "05f11f47a0105f97fe790b2e7d046fcd60d531401dca91b35d723625653b7867" => :catalina
    sha256 "f9ca60f8374c6e783046dff9498eb6edb5a48f1f044898da659dc552cd21d0f1" => :mojave
    sha256 "a8ed8cc779f4800282208052c3acb80d50b236fed75c97004d73368b2cb03e17" => :high_sierra
  end

  depends_on "geoip"
  depends_on "python"
  depends_on "ssdeep"

  resource "GeoIP" do
    url "https://files.pythonhosted.org/packages/f2/7b/a463b7c3df8ef4b9c92906da29ddc9e464d4045f00c475ad31cdb9a97aae/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/62/85/7585750fd65599e88df0fed59c74f5075d4ea2fe611deceb95dd1c2fb25b/certifi-2019.9.11.tar.gz"
    sha256 "e4f3620cfea4f83eedc95b24abd9cd56f3c4b146dd0177e83a21b4eb49e21e50"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"
    sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "ssdeep" do
    url "https://files.pythonhosted.org/packages/e0/d3/f17602a7dde1231d332f4067fdd421057ffe335c3bbc295e7ccfab769d95/ssdeep-3.4.tar.gz"
    sha256 "1b5510716bc495a2b18300ea837fcf944552a1cc678bb74e384bce251d99a85f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz"
    sha256 "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745"
  end

  resource "whois" do
    url "https://files.pythonhosted.org/packages/b3/69/563d03c4c8b662f6369961d7e52da22e070f92fd378724076c20a3cccc3b/whois-0.9.4.tar.gz"
    sha256 "ee7fd23b13cdf33b94d633a31edac9f4e4015a72455f5d669837a8ad100612ce"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    (libexec/"bin").install "dnstwist.py" => "dnstwist"
    (libexec/"bin/database").install "database/GeoIP.dat", "database/effective_tld_names.dat"
    (bin/"dnstwist").write_env_script libexec/"bin/dnstwist", :PATH => "#{libexec}/bin:$PATH"
  end

  test do
    output = shell_output("#{bin}/dnstwist -grsw brew.sh")

    assert_match version.to_s, output
    assert_match /Processing \d+ domain variants/, output
    assert_not_match /notice: missing module/, output
  end
end
