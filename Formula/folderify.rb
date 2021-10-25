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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "683eeb71c2dd1f10514d9a7223493d6f99773617ede84ed8b3dfe3f396342b83"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cd792687f566751d98e81b7a4c0d48ae0099273f4b99fc7743f2337f92dfe0c"
    sha256 cellar: :any_skip_relocation, catalina:      "ddf121696c9d8a78208377ea2abbba6cd45734b6f1dde623af4f87b2dd6244f8"
    sha256 cellar: :any_skip_relocation, mojave:        "b83fde65d2dc9eec57207c31ac7e6f89e5bac43426c0ce73776b55c57f0e2eb0"
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
