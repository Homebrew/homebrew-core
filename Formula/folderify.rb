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
    sha256 "347aeaecc665d095c16d5ce744bebb5947480d16d3d81d85ec121ace7767b0cd" => :big_sur
    sha256 "4f1e04b043d8883c45102e34ed38b276ac4234720f94c5139649704d4c2c013b" => :catalina
    sha256 "6e9484381e0014b366004b1b91843725cef8fb94336b31fa0d0fb65221a2bde5" => :mojave
    sha256 "91a981c8bdc6559770e68cde018ce4b50c993ff7a0d867cffa537ef2baf2fe21" => :high_sierra
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
