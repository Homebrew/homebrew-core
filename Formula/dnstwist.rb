class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://github.com/elceef/dnstwist/archive/20190706.tar.gz"
  sha256 "d1192a3aca209b537f54274471398ad4cd8b040551eb0469011d0231ee53520a"
  revision 2

  bottle do
    cellar :any
    sha256 "05f11f47a0105f97fe790b2e7d046fcd60d531401dca91b35d723625653b7867" => :catalina
    sha256 "f9ca60f8374c6e783046dff9498eb6edb5a48f1f044898da659dc552cd21d0f1" => :mojave
    sha256 "a8ed8cc779f4800282208052c3acb80d50b236fed75c97004d73368b2cb03e17" => :high_sierra
  end

  depends_on "geoip"
  depends_on "python@3.8"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "GeoIP" do
    url "https://files.pythonhosted.org/packages/f2/7b/a463b7c3df8ef4b9c92906da29ddc9e464d4045f00c475ad31cdb9a97aae/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "ssdeep" do
    url "https://files.pythonhosted.org/packages/e0/d3/f17602a7dde1231d332f4067fdd421057ffe335c3bbc295e7ccfab769d95/ssdeep-3.4.tar.gz"
    sha256 "1b5510716bc495a2b18300ea837fcf944552a1cc678bb74e384bce251d99a85f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  resource "whois" do
    url "https://files.pythonhosted.org/packages/c3/7c/c67420840b1873ddae02e42e8be34a1a8d6a0973a59f65d4f46fb8aa5b64/whois-0.9.6.tar.gz"
    sha256 "8a6f0b2cc3a8ef599d88cc9259e8c2616b25861b26d69bfdeddc8ccfae690b66"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"

    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
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
