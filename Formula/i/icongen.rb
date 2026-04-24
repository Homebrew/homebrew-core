class Icongen < Formula
  include Language::Python::Virtualenv

  desc "Generate icons at multiple sizes from a logo image (SVG/PNG/JPG)"
  homepage "https://github.com/zozimustechnologies/icongen"
  url "https://github.com/zozimustechnologies/icongen/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "775b87caf7c89a2753da3d7f8ea4c61e1dd335f17c39ce9ea0823e7607aba766"
  license "MIT"

  depends_on "librsvg"
  depends_on "pillow"
  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"icongen", "--version"
    system bin/"icongen", "--help"
  end
end
