class Atdtool < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://files.pythonhosted.org/packages/83/d1/55150f2dd9afda92e2f0dcb697d6f555f8b1f578f1df4d685371e8b81089/atdtool-1.3.3.tar.gz"
  sha256 "a83f50e7705c65e7ba5bc339f1a0624151bba9f7cdec7fb1460bb23e9a02dab9"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "d6b4caae97223c76d2d3f41a45ecb7721aac8f90cbcd54de2412abf60e351e59" => :catalina
    sha256 "b81608e6b0b99684c095c2e0fb88430e4e54f6b285ae85ef1355657a563be373" => :mojave
    sha256 "c0a9496c43531cd2b3d03da346ada7f938118d7dfab91cd276122feb9eb2b478" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
