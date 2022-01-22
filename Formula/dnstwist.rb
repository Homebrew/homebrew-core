class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/9e/af/673d81e5043b4f7350df64fcebfca3ac42de2c16c4f5caca0fab2f21ddc4/dnstwist-20220120.tar.gz"
  sha256 "05bd341bc4cc138cb7ec92ea217c82166371496b34dba96cc4439b0301d76fff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2db2d67e7e690d4c92dc9e0407ffc376f9983fefc22c039e29abc19de4c2f89c"
    sha256 cellar: :any,                 arm64_big_sur:  "bf760c8372a1f9683c4e286e1e33478b1b5cbf34a68161d19c0da008f764343c"
    sha256 cellar: :any,                 monterey:       "26fdf9cea3eed158bc4a290b30aa85312cf955afa2ec80e9f89f6dfbc6d40f94"
    sha256 cellar: :any,                 big_sur:        "db37fce3570b0b571f2683c4c088fdfc27df598bb164e4fac250ab208daa2a97"
    sha256 cellar: :any,                 catalina:       "04921cc3f53ea9e9cad458167fadfcc9f60e1b9c76e81954ee21b8f26ad51a5e"
    sha256 cellar: :any,                 mojave:         "188c9b6cfd70f1cd4f2921b6b0fe71b224f46949b67d292ba28e9bcf6fd8399b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63af2a88affd5f0f06ca0d41a5998e3b8d3cb7e206f587a5645861a9e0aa59cb"
  end

  depends_on "geoip"
  depends_on "python@3.10"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

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

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/c1/39/68d5ecb596e02d235fc3b0914b1bf0840d8fbc155fa6ff194eee718469d9/tld-0.12.6.tar.gz"
    sha256 "69fed19d26bb3f715366fb4af66fdeace896c55c052b00e8aaba3a7b63f3e7f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
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
