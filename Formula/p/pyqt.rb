class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/d1/f9/b0c2ba758b14a7219e076138ea1e738c068bf388e64eee68f3df4fc96f5a/PyQt6-6.7.1.tar.gz"
  sha256 "3672a82ccd3a62e99ab200a13903421e2928e399fda25ced98d140313ad59cb9"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "115b7fe876382e37b7ec6b780d081a3735d10348563fe3b319c595e71c0c1ede"
    sha256 cellar: :any,                 arm64_ventura: "ca4e7770dc38d1da7a083545aa5fa7fe93090c1d3ff63602d61bdb81757e711f"
    sha256 cellar: :any,                 sonoma:        "9dc09304736af3a852083802ed87533d7e4fd8da85219545bfdf96c5551cbc43"
    sha256 cellar: :any,                 ventura:       "480abb46fd740155ffc7da43f62a5775f12831a4223d1a0b89a3aad445097e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e48e4167527158ea52ed7eaf99c18ba4ffffa03325e7844771e639416e3096"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.13"
  depends_on "qt"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/d4/4c/fdc69a29e733e2f6fdb9a9d3f6321702502405e45cef632be4d73c1cd501/PyQt6_3D-6.7.0.tar.gz"
    sha256 "3e99bfc801918ab4758dd2660b2d2358e0057c943eb2bd9f8d0ddf156ea5ccd7"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/db/45/e60ba544339c81c879ab61e914010051ae8695cd7ffaafebf0a9adbd8bd4/PyQt6_Charts-6.7.0.tar.gz"
    sha256 "c4f7cf369928f7bf032e4e33f718d3b8fe66da176d4959fe30735a970d86f35c"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/4c/18/c4e02ea4340490f05c93307847c94debecba9510cc49af2fe913cf67869f/PyQt6_DataVisualization-6.7.0.tar.gz"
    sha256 "8cbdd50326a2cda533bc5744c85a331c84047af121bdbd64f9c00dbc06588884"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/bc/c5/fd594dec201471ccf99c27ad65a40a0c4965503f89ff798ca785b2e7c5ee/PyQt6_NetworkAuth-6.7.0.tar.gz"
    sha256 "974983525437633a0f016c0ffa0dc311847089f253dfe6840b0ec8ce21dc8685"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/e9/b7/95ac49b181096ef40144ef05aff8de7c9657de7916a70533d202ed9f0fd2/PyQt6_sip-13.8.0.tar.gz"
    sha256 "2f74cf3d6d9cab5152bd9f49d570b2dfb87553ebb5c4919abfde27f5b9fd69d4"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/87/88/230ec599944edf941f4cca8d1439e3a9c8c546715434eee05dce7ff032ed/PyQt6_WebEngine-6.7.0.tar.gz"
    sha256 "68edc7adb6d9e275f5de956881e79cca0d71fad439abeaa10d823bff5ac55001"
  end

  def python3
    "python3.13"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    sip_install = Formula["pyqt-builder"].opt_libexec/"bin/sip-install"
    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system sip_install, *args

    resource("pyqt6-sip").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~TOML
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        TOML
        system sip_install, "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system python3, "-c", "import PyQt#{version.major}"
    pyqt_modules = %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Multimedia
      Network
      NetworkAuth
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    # Don't test WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }

    # Make sure plugin is installed as it currently gets skipped on wheel build,  e.g. `pip install`
    assert_path_exists share/"qt/plugins/designer"/shared_library("libpyqt#{version.major}")
  end
end
