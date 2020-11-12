class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify.git",
    tag:      "v2.0.2",
    revision: "f7fd2cd9719be6ec1f725d6ce8b8f2d7dc941a94"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  livecheck do
    url :head
    regex(/^v\d+\.\d+\.\d+$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bf77b40c3552f1a4caebf73b6054127fa97b4f8ee41c267112801d14a5fd18be" => :catalina
    sha256 "78f9ca5c9613430633e11ba616cf69a0b3326134a73bef485e8c9e077ca82f2d" => :mojave
    sha256 "e48592da636f39b129abcaffb2a44a761bb6aa5b42164a303cef1e791fbe569f" => :high_sierra
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
