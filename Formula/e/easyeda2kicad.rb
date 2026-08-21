class Easyeda2kicad < Formula
  include Language::Python::Virtualenv

  desc "Converts electronic components from EasyEDA or LCSC to a KiCad library"
  homepage "https://github.com/uPesy/easyeda2kicad.py"
  url "https://files.pythonhosted.org/packages/ab/8b/9a7abcdbb2a3a86d55e40f59f7c28b24e7e8fe9fcc08949509fff386a9a5/easyeda2kicad-1.0.1.tar.gz"
  sha256 "122a48fafa3b918e730185c973dd342183928b8a0dbe24436d13d58b90290e84"
  license "AGPL-3.0-or-later"
  head "https://github.com/uPesy/easyeda2kicad.py.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "340ce9e2dcb623e0b5917db839b59c6f681ad4450f03a1f4059f1089d0695234"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"easyeda2kicad", "--full", "--lcsc_id=C2040", "--output", testpath/"lib"
    assert_path_exists testpath/"lib.3dshapes"
    assert_path_exists testpath/"lib.kicad_sym"
    assert_path_exists testpath/"lib.pretty"
  end
end
