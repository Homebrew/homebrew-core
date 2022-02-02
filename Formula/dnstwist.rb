class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/74/8e/4924079d630a5035e06bafcedad13bcd90cd0062205b43646726b5199bb4/dnstwist-20220131.tar.gz"
  sha256 "8c65c64651ee2fc8cccbfb0dfb30674cb326fd00855df1e9e79b46bd3d59674b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c3d4740eb6ebb03836b60103ea7fcd76fbfc9204e7a9f66a273ae17c43d31a4"
    sha256 cellar: :any,                 arm64_big_sur:  "19916b05571f5a41be59261636ec729ea1d216fcd5070069b7011e932cb0a2ff"
    sha256 cellar: :any,                 monterey:       "af0f58881870bd8c6f53514bd710e0e050a35fe44ba6e4024f5349f9aa23bd5e"
    sha256 cellar: :any,                 big_sur:        "ce4e7b77669356d22c7178ecc11cbbf4e7718e558168755cc5e546a382f57779"
    sha256 cellar: :any,                 catalina:       "d26f28e5d0544839456e95f388a45f5f0cc012661b8226bf337a68b976eb785b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d12a6835b1a103dd22c22819f0c40cae054f54f034f6bc58c7ef819e030df5a2"
  end

  depends_on "geoip"
  depends_on "python@3.10"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/84/f4/84eca79c279640671b8b7086ef1b97268c2b7ba17f7cfe0a19b466a6f95c/dnspython-2.2.0.tar.gz"
    sha256 "e79351e032d0b606b98d38a4b0e6e2275b31a5b85c873e587cc11b73aca026d6"
  end

  resource "GeoIP" do
    url "https://files.pythonhosted.org/packages/f2/7b/a463b7c3df8ef4b9c92906da29ddc9e464d4045f00c475ad31cdb9a97aae/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "ppdeep" do
    url "https://files.pythonhosted.org/packages/64/ad/ca722788606970d227b1778c158d4a04ffd8190487fa80b3273e3fa587ac/ppdeep-20200505.tar.gz"
    sha256 "acc74bb902e6d21b03d39aed740597093c6562185bfe06da9b5272e01c80a1ff"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/c1/39/68d5ecb596e02d235fc3b0914b1bf0840d8fbc155fa6ff194eee718469d9/tld-0.12.6.tar.gz"
    sha256 "69fed19d26bb3f715366fb4af66fdeace896c55c052b00e8aaba3a7b63f3e7f0"
  end

  resource "whois" do
    url "https://files.pythonhosted.org/packages/c5/30/187055e24b91a54c5502496b05b7f33ce70566e8f8e1fc8f25eb243b7dd1/whois-0.9.13.tar.gz"
    sha256 "478a4f10673412d774078f74302b2b62cbab20fbda9216918815687582a0c68d"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    (libexec/"bin").install "dnstwist.py" => "dnstwist"
    (bin/"dnstwist").write_env_script libexec/"bin/dnstwist", PATH: "#{libexec}/bin:$PATH"
  end

  test do
    output = shell_output("#{bin}/dnstwist -rsw brew.sh 2>&1")

    assert_match version.to_s, output
    assert_match "brew.sh", output
    assert_match "NS:ns1.dnsimple.com", output
  end
end
