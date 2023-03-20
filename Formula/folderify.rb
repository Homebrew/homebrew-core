class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/4c/18/a4d6491e4f64cbff4821cefa9fec1cfcb3048e19fc806d7e9af876654b94/folderify-2.4.0.tar.gz"
  sha256 "daf1f5c64d59528d61d5a223d9ad2ba8f0e10ffd0d9cc2286ccd65b7fa516c24"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2b1e1d23423c152acb05f34a26cd5e6c5480116bc63a2868cef9659f1a42837"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42d0a7a535288bd8479f5071e8a973e8027bcaa259437667b20c50a2c4b9285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bb8a9116732629a9698c44f2f533560a325dcd7a1eadbfbc7473598e07889da"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e1ee0027d66edcb184e0f8653d7bcea684dd511881c5bab69876d053dff8a6"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e1ee0027d66edcb184e0f8653d7bcea684dd511881c5bab69876d053dff8a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a714d0ecddc788eae807a62b55dcd6f7d5d864a3b0da91ba3446dfb5d6b9337"
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
