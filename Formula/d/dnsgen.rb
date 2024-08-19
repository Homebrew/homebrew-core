class Dnsgen < Formula
  include Language::Python::Virtualenv

  desc "Generates DNS names from existing domain names"
  homepage "https://github.com/AlephNullSK/dnsgen"
  url "https://files.pythonhosted.org/packages/5f/e1/1c7d86f51da5b93f3f99ac99e3ad051ed82234147ddd869f77a3959e6abc/dnsgen-1.0.4.tar.gz"
  sha256 "1087e9e5c323918aa3511e592759716116a208012aee024ffdbeac5fce573a0c"
  license "MIT"
  head "https://github.com/AlephNullSK/dnsgen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38fe8f1e5c63609f9af6c9f7be7a388f9356f2c5d2022af50062bf909b184b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38fe8f1e5c63609f9af6c9f7be7a388f9356f2c5d2022af50062bf909b184b2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38fe8f1e5c63609f9af6c9f7be7a388f9356f2c5d2022af50062bf909b184b2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "38fe8f1e5c63609f9af6c9f7be7a388f9356f2c5d2022af50062bf909b184b2a"
    sha256 cellar: :any_skip_relocation, ventura:        "38fe8f1e5c63609f9af6c9f7be7a388f9356f2c5d2022af50062bf909b184b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "38fe8f1e5c63609f9af6c9f7be7a388f9356f2c5d2022af50062bf909b184b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e142090204b7f6b028c213e3eeb137390dd57bb8a47cff77ad2ef66d973ffc"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/7d/98/6e68cf474669042ba6ba0a7761b8be04beb8131b366d5c6b1596f8cdfec2/filelock-3.15.3.tar.gz"
    sha256 "e1199bf5194a2277273dacd50269f0d87d0682088a3c561c15674ea9005d8635"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/72/97/bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1ae/requests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/db/ed/c92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739/tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"domains.txt").write <<~EOS
      example.com
      example.net
    EOS

    output = shell_output("#{bin}/dnsgen domains.txt")
    assert_match "beta.example.com", output
  end
end
