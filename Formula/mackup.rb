class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/ef/39/2da64e9e92092eae9128de719249cdfbfb5e2b56cba842547ce256e03ef4/mackup-0.8.32.tar.gz"
  sha256 "154c5d78951e20da2ed0ed226b0684d2bc7f5553dd7b465f217fd6caad6e7fef"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "24dca4cbc991aad8990c672e7a88fd975f33fefcdb0dbb70f9e6e0b10a19841d" => :big_sur
    sha256 "be968ec450c3e2c28255f2c6e7928404e24498c907a05aed69e5a87e6ae8612e" => :arm64_big_sur
    sha256 "df736bcc51887e9621c00d2948c989db4f1d4b5234ab7e702b49933fc212705e" => :catalina
    sha256 "5f413d937d26828065204eaf532ab280c9d642448a0ee4f280fc667cb03fc9e6" => :mojave
  end

  depends_on "python@3.9"

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
