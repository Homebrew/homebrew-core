class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/68/03/a4834a40d95a0bc2debdbad7e0e1bf909a95ff68c0a64098ea52f6ccb794/folderify-2.3.1.tar.gz"
  sha256 "0927c9453dc8efb6ea4addb0eee2711528152045f22d411c9de1e7f45621f06c"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b610453fd265bd5f0157f73f4583711f89a6c60cc43b268bbfcb3e2ac92d1af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c63ee93c4d07a464d42c2eb7b031d499a5299cd212698e6837a9caac4ca057bd"
    sha256 cellar: :any_skip_relocation, monterey:       "b5bfc862becaed4ab92f5ea9e70e66b513519f2ff90e1ff11c5c3a2f1ab385f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea6a49e79e5751377bcad72652106a199ee8b3890ec107bbd7713bc210abea99"
    sha256 cellar: :any_skip_relocation, catalina:       "bc8fe9f16503eb1c6d37770d799325aa6dd69a6801dcde99a9e43b4ab47eb697"
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
