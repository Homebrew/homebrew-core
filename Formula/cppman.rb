class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/1f/d1/96e8ad31e41763743137c3e3eeaee97e999e68af4bf4c270de661344267c/cppman-0.5.4.tar.gz"
  sha256 "7884783a149a1aceb801e278f85e2e62da89abe910854e6fdf7a99a1e08d94a3"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb24326a3701f41e0615a6e25ad66a45d37d8babc5c1fc4726bfce1e20cc5e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0252327b9af79af317995a3c5009ec6597e176249aa9936896938d0f00d6a10c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a01c8d3c53feda1e33ebaa0158e94d773fa684b72f9ef0a327a7f7c5853d2fd"
    sha256 cellar: :any_skip_relocation, monterey:       "069e7ddf142eb7e099a33a270f29bd43ff236ea31ee2ae35dcd091050a4f5998"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e7ae00951377abc373d6b7ebd0a5b56ad2f8e61d44dcb1259de72efff15efe3"
    sha256 cellar: :any_skip_relocation, catalina:       "8956831dfe6267c97db370432672985bfce0f1d72de05c545834d5274fab55bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ca1a07667642afec48589de3e2e18cb9ce5d3ca7ed3ca11f7c063ae13af3f7"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "std::extent", shell_output("#{bin}/cppman -f :extent")
  end
end
