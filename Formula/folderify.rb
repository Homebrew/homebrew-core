class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pretty, beveled macOS folder icons"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/v1.2.3.tar.gz"
  sha256 "3a9eaadf1f2a9dde3ab58bb07ea5b1a5f5a182f62fe19e2cd79a88f6abe00f7e"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  depends_on "imagemagick"
  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    # Copies an example icon
    cp("#{libexec}/lib/python3.8/site-packages/folderify/GenericFolderIcon.Yosemite.iconset/icon_16x16.png",
    "icon.png")
    # folderify applies the test icon to a folder
    system "folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
