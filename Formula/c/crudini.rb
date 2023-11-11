class Crudini < Formula
  include Language::Python::Virtualenv

  desc "Utility for manipulating ini files"
  homepage "https://github.com/pixelb/crudini"
  url "https://files.pythonhosted.org/packages/32/67/c4e838930e2f434db08d6a6aadffca3d14e7455d1c2c2332e22003ad453d/crudini-0.9.5.tar.gz"
  sha256 "59ae650f45af82a64afc33eb876909ee0c4888dc4e8711ef59731c1edfda5e24"
  license "GPL-2.0-or-later"

  depends_on "python@3.12"
  depends_on "six"

  resource "iniparse" do
    url "https://files.pythonhosted.org/packages/4c/9a/02beaf11fc9ea7829d3a9041536934cd03990e09c359724f99ee6bd2b41b/iniparse-0.5.tar.gz"
    sha256 "932e5239d526e7acb504017bb707be67019ac428a6932368e6851691093aa842"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/crudini", "--version"
  end
end
