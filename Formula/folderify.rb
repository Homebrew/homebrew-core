class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/68/03/a4834a40d95a0bc2debdbad7e0e1bf909a95ff68c0a64098ea52f6ccb794/folderify-2.3.1.tar.gz"
  sha256 "0927c9453dc8efb6ea4addb0eee2711528152045f22d411c9de1e7f45621f06c"
  license "MIT"
  revision 1
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35bc64a01041e596b159c71533eb632ad3d2a278b3f850d5bc2dea5ff5b542c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b9491bd61efa21a3fb11de4048bf3976549737f5519fa9c8707d3d29aa88495"
    sha256 cellar: :any_skip_relocation, monterey:       "d494fd1ad63d3dbee0d088fea5ccaaea738f790a4c0017f60d1c9933cfa6dc57"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c35e9f509ca6b82360b58f5ce7ddf8f08f2922ac88357e298846849400cab8a"
    sha256 cellar: :any_skip_relocation, catalina:       "f77da3ff2274fcff4d3fec345b63f31d8d2eb21b9d59a59f1b9e236b3567fc3a"
  end

  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos
  depends_on "python@3.10"

  resource "osxiconutils" do
    url "https://github.com/sveinbjornt/osxiconutils.git",
        revision: "d3b43f1dd5e1e8ff60d2dbb4df4e872388d2cd10"
  end

  def python3
    "python3.10"
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
    system "folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
