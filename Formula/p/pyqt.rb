class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/e9/0a/accbebed526158ab2aedd5c84d238159754bd99f481082b3fe7f374c6a3b/PyQt6-6.8.0.tar.gz"
  sha256 "6d8628de4c2a050f0b74462e4c9cb97f839bf6ffabbca91711722ffb281570d9"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "4ee6b869bf446efb3547621e50fec47d5d6933b1cd3cdd17eee7bc4cddb94182"
    sha256 cellar: :any,                 arm64_ventura: "78406197de51117f825a6769af4cb068349a50da113f1398a13a94b6fd53d6a0"
    sha256 cellar: :any,                 sonoma:        "fa2f3e4ae72c5de5f79347401b631372ccf12f57cff2571f4de891bfea68de94"
    sha256 cellar: :any,                 ventura:       "5f2493c14c6ca882b8222d7d6ed4e008c8f840f2cc1225f5a1b8a950f95a886b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0781bd7c55ef7442e99db90f38d1c29851be123072d6d6d358cba82b117a0f4c"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.13"
  depends_on "qt"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/13/15/4eef4a5087e4af01638baee8fd1c22e97fce2eb593e73c7f1cf9f59dffa9/PyQt6_3D-6.8.0.tar.gz"
    sha256 "f62790a787cfc99fcd84c774fa952b83c877dd2175355a3a6609d37fe1a1c7a3"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/94/51/d37e1527dcf0e2bf5bfdba4200c2297a4224e299d79c4d4cfbe1a363e01b/PyQt6_Charts-6.8.0.tar.gz"
    sha256 "f86705b8740e3041667ce211aeaa205b750eb6baf4c908f4e3f6dc8c720d10f1"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/3c/26/9006f1ff80fe800df3ea1b6f26bf61323e19acede5a3e55a115908638689/PyQt6_DataVisualization-6.8.0.tar.gz"
    sha256 "822a94163b8177b9dd507988aff4da7c79ce26bc47fc5f9780dea6989c531171"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/ee/79/3d67110608e7e6b55c501359699826dd861c21c668ccc9a8fbc99bfc528b/PyQt6_NetworkAuth-6.8.0.tar.gz"
    sha256 "2a1043ff6d03fc19e7bc87fad4f32d4d7e56d2bf1bb89b2a43287c0161457d59"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/90/18/0405c54acba0c8e276dd6f0601890e6e735198218d031a6646104870fe22/pyqt6_sip-13.10.0.tar.gz"
    sha256 "d6daa95a0bd315d9ec523b549e0ce97455f61ded65d5eafecd83ed2aa4ae5350"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/cd/c8/cadaa950eaf97f29e48c435e274ea5a81c051e745a3e2f5d9d994b7a6cda/PyQt6_WebEngine-6.8.0.tar.gz"
    sha256 "64045ea622b6a41882c2b18f55ae9714b8660acff06a54e910eb72822c2f3ff2"

    # Apply Arch Linux patch to fix build
    patch do
      url "https://gitlab.archlinux.org/archlinux/packaging/packages/pyqt6-webengine/-/raw/85846264bbfd2628fae66786e2f48ae40fddadca/fix-build.patch"
      sha256 "14b523cf26fd6e066ed1900fd59e1e6f8d7abc5900a04fc5b9bc9f3cb831045f"
    end
  end

  # Apply Arch Linux patch to fix build with Qt 6.8.2.
  # TODO: Remove on the next release as fix is in pre-release for PyQt 6.8.1
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/pyqt6/-/raw/0877bb909ba3b9715300ac9f9f82f47c5eeb9209/qt-6.8.2.patch"
    sha256 "c7dfae13566128bdf9c0503960d754109b35ca93d3f6af1aa56a554b5dc99a63"
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
      next if r.name == "pyqt6-webengine" && OS.mac? && MacOS.version <= :ventura

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~TOML
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        TOML
        system sip_install, "--target-dir", site_packages, "--verbose"
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
    pyqt_modules << "WebEngineCore" if OS.linux? || MacOS.version > :ventura
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }

    # Make sure plugin is installed as it currently gets skipped on wheel build,  e.g. `pip install`
    assert_path_exists share/"qt/plugins/designer"/shared_library("libpyqt#{version.major}")
  end
end
