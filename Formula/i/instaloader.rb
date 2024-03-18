class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/7e/35/1f8d36c0656d4797fc5089c016995447f2b439e8fb9df02bf9d7873566fc/instaloader-4.11.tar.gz"
  sha256 "7478a1f0ed5c05911832c50cb19747243a461b5d434907f9fdb7d2d750d1b4f5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95ef1c90d5de63fdb77a891424cb778fcfec4268fe5390bbf34722b584e375f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3366c05d9bceba70d467fb431adf77fdf9154477d2e400c538e63f881b390207"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a87da3e3ab26cd1286bdb89a005d3c10a97b5353c2d1ce0e3f3bd1b4ffb7cc86"
    sha256 cellar: :any_skip_relocation, sonoma:         "527483287295939b17ba78254f764b5d6c3148560525ff9bc8083a940ca8f502"
    sha256 cellar: :any_skip_relocation, ventura:        "16415cf0e56b69f1979b9cccb71da6d667d799adc34909e4b82cd76341bbfa86"
    sha256 cellar: :any_skip_relocation, monterey:       "a439a75b7a9129aaa91457a24f1a31a473a9a1b2565732d6569dff9dd702b90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2524ecc531ed61a9b29c91230373251d589bdbdbecb1f829262fb3b07805a12c"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end
