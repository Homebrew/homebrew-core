class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify.git",
    tag:      "v2.0.0",
    revision: "84374fc7394f41035c07b9a7b37dd59d26747836"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  livecheck do
    url :head
    regex(/^v\d+\.\d+\.\d+$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b837787fcfa5ae9ef08f2aeb51fc58174295b9139411b199db8f167f6fbfda9f" => :catalina
    sha256 "61656a834653ba71b4b57555ca1f70d4132a3fb9ca3003b8b7d8f4444fc68a6a" => :mojave
    sha256 "b6190ad9db316c5021d6a3a13e1ca98e2aa56d0cb47347a1671a8aaf3e722f88" => :high_sierra
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
