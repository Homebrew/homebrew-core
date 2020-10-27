class Atdtool < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://files.pythonhosted.org/packages/83/d1/55150f2dd9afda92e2f0dcb697d6f555f8b1f578f1df4d685371e8b81089/atdtool-1.3.3.tar.gz"
  sha256 "a83f50e7705c65e7ba5bc339f1a0624151bba9f7cdec7fb1460bb23e9a02dab9"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f9e3111dd7fc68392f8916623df911076d0c6ed2bcbb294eda942c136fd962c3" => :catalina
    sha256 "d35df10b09cdcd186178a1101d181c662f37903179438f31d0ec142cc830da93" => :mojave
    sha256 "5a11e4ab56f3b02990418612c81f0538b8ea6161d15e5bac2932208ee5293055" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
