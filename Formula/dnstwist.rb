class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://github.com/elceef/dnstwist/archive/20190619.tar.gz"
  sha256 "234e69bf8b6696db627dcde6b5f058c014745e1bf98c0531e75b7912c844348f"

  bottle do
    cellar :any
    sha256 "617f6a0ac1e6a1895d47d8fcf0cc60c943cc94fefe8032915d7a0eb6ca19adc1" => :mojave
    sha256 "122933e791a84887fec179c3209f3cd6191c9532b5cf3ba9e50cc407ae110426" => :high_sierra
    sha256 "fd55c78cc7ff80c5ddfa6a49b2902b9fa667302a32984a20a0a20bc2b5093427" => :sierra
  end

  depends_on "geoip"
  depends_on "python"
  depends_on "ssdeep"

  resource "GeoIP" do
    url "https://files.pythonhosted.org/packages/f2/7b/a463b7c3df8ef4b9c92906da29ddc9e464d4045f00c475ad31cdb9a97aae/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e1/0f/f8d5e939184547b3bdc6128551b831a62832713aa98c2ccdf8c47ecc7f17/certifi-2018.8.24.tar.gz"
    sha256 "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/e4/96/a598fa35f8a625bc39fed50cdbe3fd8a52ef215ef8475c17cabade6656cb/dnspython-1.15.0.zip"
    sha256 "40f563e1f7a7b80dc5a4e76ad75c23da53d62f1e15e6e517293b04e1f84ead7c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "ssdeep" do
    url "https://files.pythonhosted.org/packages/96/54/15b2e0b6e5042b67eb648e3d0e5d10105e6797353fe0a63579b74bf5eeee/ssdeep-3.3.tar.gz"
    sha256 "255de1f034652b3ed21920221017e70e570b1644f9436fea120ae416175f4ef5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  resource "whois" do
    url "https://files.pythonhosted.org/packages/5a/b0/c08d2d3dcd35f10ddf51b072c471872a1f426025045eb361feeac5c7e5a6/whois-0.8.tar.gz"
    sha256 "078298e68dee9ba0d6a2bc58a6987d9f4151e09ae0ea3b4c8c8d3dac0e7a709b"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    (libexec/"bin").install "dnstwist.py" => "dnstwist"
    (libexec/"bin/database").install "database/GeoIP.dat", "database/effective_tld_names.dat"
    bin.write_exec_script libexec/"bin/dnstwist"
  end

  test do
    output = shell_output("#{bin}/dnstwist github.com")

    assert_match version.to_s, output
    assert_match /Processing \d+ domain variants/, output
  end
end
