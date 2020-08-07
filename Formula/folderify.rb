class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pretty, beveled macOS folder icons"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/v1.2.3.tar.gz"
  sha256 "3a9eaadf1f2a9dde3ab58bb07ea5b1a5f5a182f62fe19e2cd79a88f6abe00f7e"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    cellar :any_skip_relocation
    sha256 "062b16879ed2d131b59c248742e264c5a0408cf2920726e7a8e5748e8f26311e" => :catalina
    sha256 "53fe9712af93934f58d7240be8352a1bba5af825c125ed299a436b652c5c9f8a" => :mojave
    sha256 "73e6e1481a6be47c97ffb05bfde6721e48096c9ad574a29917f680599acc9bff" => :high_sierra
  end

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
