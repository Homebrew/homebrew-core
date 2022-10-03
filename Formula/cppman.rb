class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/1f/d1/96e8ad31e41763743137c3e3eeaee97e999e68af4bf4c270de661344267c/cppman-0.5.4.tar.gz"
  sha256 "7884783a149a1aceb801e278f85e2e62da89abe910854e6fdf7a99a1e08d94a3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ca30d561477d9d2dc9f358ca8ee1667de84768086fa6a5915295c755e8c4f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7be03e0509903bce8c018175cffdf173e339456aa555cb91a86e5093feab947"
    sha256 cellar: :any_skip_relocation, monterey:       "6a88f88450153e891a470d20482131005fdf1c26d3eeb5da819b2ce7d351183b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d9a3470010dac2167e6bf34e165a5ed30ade83fd3d435e0ec47ecea37c7391"
    sha256 cellar: :any_skip_relocation, catalina:       "2604a65f2ec97aa523f1efdb7723fd85009ba2b357891dcfb9a912737fdc1b9b"
    sha256 cellar: :any_skip_relocation, mojave:         "cb190a51ebdbf7c322627b64665c9384cb2f161a30158e5211aa700fead3b507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee5f9cc3bca54588fa24dafc9379f81c0eeeeb59b3c46dc5587074450b7bf14"
  end

  depends_on "python@3.10"
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
