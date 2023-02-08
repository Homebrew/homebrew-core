class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/11/cc/d8a2f0610f5c6ec9a876d692ceca1ead7f3d783bd57d6476794fd039cdd7/folderify-2.3.2.tar.gz"
  sha256 "de59077ce0c8f00fe06a30156fc0f3df2d8f608036e09be7354ca6a50e66ccc1"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b7b3a757b796c9187214e29f0c9869b336e6e8f940c525793c831acf35a07ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb543760ad4756b93cbc0faaf2cabbbaa8f6a6368f1b2ce2d0e022ed68387ce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aed264df86c7e14cca63a144f882f8396f7b1b27caedcc4f67e228d79a64e443"
    sha256 cellar: :any_skip_relocation, ventura:        "3b049af3264f7be4537400b18936d84780a9588f20db1c05a5d41f447556cc9b"
    sha256 cellar: :any_skip_relocation, monterey:       "3b049af3264f7be4537400b18936d84780a9588f20db1c05a5d41f447556cc9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "894af8d22b7b79072bfe71a9c30891052a133e3850c8632b4499ccd28ef36bee"
  end

  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos
  depends_on "python@3.11"

  resource "osxiconutils" do
    url "https://github.com/sveinbjornt/osxiconutils.git",
        revision: "d3b43f1dd5e1e8ff60d2dbb4df4e872388d2cd10"
  end

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3, system_site_packages: false)
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

      (libexec/Language::Python.site_packages(python3)/"folderify/lib").install "build/seticon"
    end
  end

  test do
    # Copies an example icon
    site_packages = libexec/Language::Python.site_packages(python3)
    cp(
      "#{site_packages}/folderify/GenericFolderIcon.Yosemite.iconset/icon_16x16.png",
      "icon.png",
    )
    # folderify applies the test icon to a folder
    system bin/"folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
