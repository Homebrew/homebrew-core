class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify.git",
    tag:      "v2.1.0",
    revision: "b2269ee12500c5cc58ebba264c77492ef13abbcc"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  livecheck do
    url :head
    regex(/^v\d+\.\d+\.\d+$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "24bd0be942afbcad738fc218fb366f72bd0412d919df12fabd4213ba1acb4d49" => :catalina
    sha256 "4f70b06824296a3d0c644ded76dc6646149f8def035ad6236be5dbc252359bf5" => :mojave
    sha256 "3288b838b00e73ac8d37955f4f1f83b6b34695f39c6b5fa6d21c9d85cf3d4138" => :high_sierra
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
