class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/4a/ae/77e25559b76ec9e4e5df9f2173b8e008b6199b3049d4fb8d4207bbf68fff/folderify-2.1.1.tar.gz"
  sha256 "4167dcd86878fa0115101959d5437531954a6707dbe207f8cb45425a4547d730"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b54441414ed46cb54a40fdd64dc8e0d1457d5cc370809417073705eefd2e9a81" => :big_sur
    sha256 "c3ef91fc66d46514d556f7d0cbf038a09e80dee34c5aaec7ee6efcebeb98378e" => :catalina
    sha256 "c86cb0415afa5a41e2c2d4f7e9ca2a9035187ad14ab4c750dd1adf4a7133c9c7" => :mojave
  end

  depends_on "imagemagick"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # Copies an example icon
    cp("#{libexec}/lib/python3.9/site-packages/folderify/GenericFolderIcon.Yosemite.iconset/icon_16x16.png",
    "icon.png")
    # folderify applies the test icon to a folder
    system "folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
