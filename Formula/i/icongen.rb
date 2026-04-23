class Icongen < Formula
  include Language::Python::Virtualenv

  desc "Generate icons at multiple sizes from a logo image (SVG/PNG/JPG)"
  homepage "https://github.com/zozimustechnologies/icongen"
  url "https://github.com/zozimustechnologies/icongen/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "775b87caf7c89a2753da3d7f8ea4c61e1dd335f17c39ce9ea0823e7607aba766"
  license "MIT"

  depends_on "librsvg"
  depends_on "python@3.12"

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/8c/21/c2bcdd5906101a30244eaffc1b6e6ce71a31bd0742a01eb89e660ebfac2d/pillow-12.2.0.tar.gz"
    sha256 "a830b1a40919539d07806aa58e1b114df53ddd43213d9c8b75847eee6c0182b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"icongen", "--version"
    system bin/"icongen", "--help"
  end
end
