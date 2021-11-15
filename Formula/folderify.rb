class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/d3/0f/a583af50a89382a877e21e3bfd84aa8698933933cce0603827534de9bf91/folderify-2.3.0.tar.gz"
  sha256 "ae3d3c7630907443f3235006fe35951615fb6184faae9752634b95c061e8c440"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68b49ad69eb36e667248dc70d280aec004326bcc1ba2c8781bb4b4a9861d012d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f23140f05c7945a01956c497f99afb19d2311d698ed8517700ff6a9a258440cb"
    sha256 cellar: :any_skip_relocation, monterey:       "ad381060d3f6c9f0ec3adfff8bcf097cf6641aafcb977c6a84ae23d4a3adb00c"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3a4f0cf34914c5e213575c455fe118d68817cb8d00646af56974fc95043a89"
    sha256 cellar: :any_skip_relocation, catalina:       "0b8b02a03816f925f515c998cac99c2c37111e1e329fffe6f1aa413069695af3"
  end

  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos
  depends_on "python@3.9"

  resource "osxiconutils" do
    url "https://github.com/sveinbjornt/osxiconutils.git",
        revision: "d3b43f1dd5e1e8ff60d2dbb4df4e872388d2cd10"
  end

  def install
    venv = virtualenv_create(libexec, "python3", system_site_packages: false)
    venv.pip_install_and_link buildpath

    # Replace bundled pre-built `seticon` with one we built ourselves.
    resource("osxiconutils").stage do
      xcodebuild "-arch", Hardware::CPU.arch,
                 "-parallelizeTargets",
                 "-project", "osxiconutils.xcodeproj",
                 "-target", "seticon",
                 "-configuration", "Release",
                 "CONFIGURATION_BUILD_DIR=build",
                 "SYMROOT=."

      (libexec/Language::Python.site_packages("python3")/"folderify/lib").install "build/seticon"
    end
  end

  test do
    # Copies an example icon
    cp(
      libexec/"lib/python3.9/site-packages/folderify/GenericFolderIcon.Yosemite.iconset/icon_16x16.png",
      "icon.png",
    )
    # folderify applies the test icon to a folder
    system "folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
