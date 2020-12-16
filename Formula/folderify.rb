class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify.git",
      tag:      "v2.1.1",
      revision: "7ca2e7e3f0fc51a370e480a879f87d8ea4e5ab51"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  livecheck do
    url :head
    regex(/^v\d+\.\d+\.\d+$/i)
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
