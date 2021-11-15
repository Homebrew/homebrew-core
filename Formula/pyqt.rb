class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/63/14/342909751d8cb6931ca1548a9834f5f581c69c2bc5836e65a8aeee9f1bb7/PyQt6-6.2.0.tar.gz"
  sha256 "142ce7fa574d7ebb13fb0a2ebd18c86087c35829f786c094a71a0749155d8fee"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_monterey: "6a6d75369b0cb8fe66474e7f8de0671963eb1e84209a5aec979448d4a2d677ef"
    sha256 cellar: :any, arm64_big_sur:  "8596b3e51d9d7c34f0b7808866e9a9a4f24d39f446da3277b833c29dcc271fcc"
    sha256 cellar: :any, monterey:       "fa0f0e9dbd2cf86aebb00d68c707b761caaf822a54a6116dc514cd120d795ce9"
    sha256 cellar: :any, big_sur:        "22d736f182cd8c634cc7a54df46d85ddfd6c539105b79feec69fd1804ed78e63"
    sha256 cellar: :any, catalina:       "b5d8b96aead59e1f9c7905d6a5841a6da1fd5d4b6b923c8598a9f65f72136715"
    sha256 cellar: :any, mojave:         "679c7ed82d6a766d5adf794dedf19b499234431629003f45ff265d5f4ac41a6f"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.9"
  depends_on "qt"

  # extra components
  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/50/24/743c4dd6a93d25570186a7940c4f072db1cf3fa919169b0ba598fcfc820a/PyQt6_sip-13.1.0.tar.gz"
    sha256 "7c31073fe8e6cb8a42e85d60d3a096700a9047c772b354d6227dfe965566ec8a"
  end

  resource "3d" do
    url "https://files.pythonhosted.org/packages/9d/63/5dcfdbfcb3d7a8da5e23c66e57425f5954786c82273dd70cc70232d98b4e/PyQt6_3D-6.2.0.tar.gz"
    sha256 "12b5c843a94fe1521d71a0c6a7ebd0a9f1f32c6fbaed896e5cda378b1831121c"
  end

  resource "charts" do
    url "https://files.pythonhosted.org/packages/51/95/8ada6ff8741c674d739c989cf3fe2594327269e7e895c2c8bbb68118eaa9/PyQt6_Charts-6.2.0.tar.gz"
    sha256 "4ea4b6b2a6c2ae7643a33534acda9bee0b5308748a34529c9f09523167b3379c"
  end

  resource "datavis" do
    url "https://files.pythonhosted.org/packages/af/6d/31be015a16528c599ed33f1b6f014b67bc3879823fa52b45d6a2bc89f0d4/PyQt6_DataVisualization-6.2.0.tar.gz"
    sha256 "7526bfd9433acb8eabdb354ba9e027d1bb34b8fa9d14f299d4b3b4c81a21e37a"
  end

  resource "networkauth" do
    url "https://files.pythonhosted.org/packages/e6/f7/cac9c0f5f9ad977576a86131dd1376d3c2b91398ccaa8288691a278449aa/PyQt6_NetworkAuth-6.2.0.tar.gz"
    sha256 "23e730cc0d6b828bec2f92d9fac3607871e6033a8af4620e5d4e3afc13bd6c3c"
  end

  resource "webengine" do
    url "https://files.pythonhosted.org/packages/8d/ce/a38c0ec1186441ed7fdc58f417c3ae8ab82cc62172986d9960dec0d2f905/PyQt6_WebEngine-6.2.0.tar.gz"
    sha256 "4f12a984efd01d202a89baea3437c6fb2001a042f9bdef512d324eb4e81ef693"
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
      # TODO: Enable webengine on linux when chromium support python3
      next if r.name == "webengine" && (OS.linux? || DevelopmentTools.clang_build_version <= 1200)

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]\n"
        # Workaround from https://www.riverbankcomputing.com/pipermail/pyqt/2021-October/044282.html
        # TODO: Remove `, "--concatenate", "1"`
        system "sip-install", "--target-dir", site_packages, "--concatenate", "1"
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}"
    %w[
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
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
