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
    rebuild 2
    sha256 "de4134789053813c8779bdbf1f0a4561fc1334c976028ae11f9f2fe1bd77a8d5" => :big_sur
    sha256 "1b56e80d1b6eabac87521806039b4cf15c625f35f63d0a8c636a1e82025ca53d" => :arm64_big_sur
    sha256 "388a1cdd813fd6be004e6b19caf157e51fd66546353e8d7d5a991dd9479f5647" => :catalina
    sha256 "e945cc2979f3f0517ab567db78d311aeb3bfb3df6062916612b583c39df9033d" => :mojave
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
