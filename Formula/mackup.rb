class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/ef/39/2da64e9e92092eae9128de719249cdfbfb5e2b56cba842547ce256e03ef4/mackup-0.8.32.tar.gz"
  sha256 "154c5d78951e20da2ed0ed226b0684d2bc7f5553dd7b465f217fd6caad6e7fef"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/lra/mackup.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5dc05ca10495128e772c5686eee80c19ff181cdf0d084646f2fcc56b29ea38d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5dab8e898d9c1806411bd637031b3472d704dfb11759bd46e565e02c736a039"
    sha256 cellar: :any_skip_relocation, catalina:      "d5dab8e898d9c1806411bd637031b3472d704dfb11759bd46e565e02c736a039"
    sha256 cellar: :any_skip_relocation, mojave:        "d5dab8e898d9c1806411bd637031b3472d704dfb11759bd46e565e02c736a039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d28d4a984579ad64589bacf2b3e54787b1819e4a4a15df85877501e373c4a5"
  end

  depends_on "python@3.10"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
