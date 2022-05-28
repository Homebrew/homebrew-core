class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/1a/54/793f2a2408fd7774361faf99ecf1e276e787e0cbc3062161e2c54d94df33/PyQt6-6.3.0.tar.gz"
  sha256 "4fd85dcb15ea4e734b6e4e216fe9a6246779761edaf2cf7c0cce1a2303a8d31b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "6a6d75369b0cb8fe66474e7f8de0671963eb1e84209a5aec979448d4a2d677ef"
    sha256 cellar: :any, arm64_big_sur:  "8596b3e51d9d7c34f0b7808866e9a9a4f24d39f446da3277b833c29dcc271fcc"
    sha256 cellar: :any, monterey:       "fa0f0e9dbd2cf86aebb00d68c707b761caaf822a54a6116dc514cd120d795ce9"
    sha256 cellar: :any, big_sur:        "22d736f182cd8c634cc7a54df46d85ddfd6c539105b79feec69fd1804ed78e63"
    sha256 cellar: :any, catalina:       "b5d8b96aead59e1f9c7905d6a5841a6da1fd5d4b6b923c8598a9f65f72136715"
    sha256 cellar: :any, mojave:         "679c7ed82d6a766d5adf794dedf19b499234431629003f45ff265d5f4ac41a6f"
    sha256               x86_64_linux:   "85d03083beca8fcb1850c787460f618ff59bea7c8c3f320e8ae0225352142c4c"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.9"
  depends_on "qt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # extra components
  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/80/1a/52b23708e45f5da117caea0ec177ea89cd21395db993c7a1fb40c25f845e/PyQt6_sip-13.3.1.tar.gz"
    sha256 "d629c0e39d5ccfdae567b92ba74d92f9180b7c55535f82251f1a12a9076a9e01"
  end

  resource "3d" do
    url "https://files.pythonhosted.org/packages/79/bc/5e2c0919b787eb59346a13b0938ec00ea2223c4b7b882af44f31b8242e55/PyQt6_3D-6.3.0.tar.gz"
    sha256 "fab024b7fb3245d9b463029e0000f46cff95f0bdab603b875fabcaa53d9fe63f"
  end

  resource "charts" do
    url "https://files.pythonhosted.org/packages/d4/c4/2b9bc7a69794f0a11b6ff4a0e4bbe008b513c8a5a2266fc69570d9f093cf/PyQt6_Charts-6.3.0.tar.gz"
    sha256 "65f0abd36305884bcae6ac837f8bbcf301873cbeeea7af9f0269f4a7c1a8ae2b"
  end

  resource "datavis" do
    url "https://files.pythonhosted.org/packages/21/19/d74bec74d696889fa768f63c2724ff92a1cd62be2cdda18fcc014b5fc0a9/PyQt6_DataVisualization-6.3.0.tar.gz"
    sha256 "f3e39f04e15fa022d8343db108af03c462de81d98c07efccb0e4b6d29292f537"
  end

  resource "networkauth" do
    url "https://files.pythonhosted.org/packages/3c/75/64bd1f9c9ff50f28e3b5e6938d10b82ee10f9669c1e140ad08b9aec8e7a9/PyQt6_NetworkAuth-6.3.0.tar.gz"
    sha256 "b1434b349e0820649341accf78689e9efd2c73543ed7d5474f660aaea2708454"
  end

  resource "webengine" do
    url "https://files.pythonhosted.org/packages/eb/ac/9deb287f98b3f8fa6227c6ca73d763c5d89d292d56c20d4057831f0c62e8/PyQt6_WebEngine-6.3.0.tar.gz"
    sha256 "ab2aedbeec54f1bcff872f7dfc236aa0fce4b55cd30f608ca89b408ee9e8147b"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    site_packages = prefix/Language::Python.site_packages("python3")
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("PyQt6-sip").stage do
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    resources.each do |r|
      next if r.name == "PyQt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "webengine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]\n"
        system "sip-install", "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}"
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
    pyqt_modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
