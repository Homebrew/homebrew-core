class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/b2/c9/266b12a9826452e387f0ff4f0b4bbd29e11d2de81a5f60c0975933b34e7f/PyQt6-6.4.0.tar.gz"
  sha256 "91392469be1f491905fa9e78fa4e4059a89ab616ddf2ecfd525bc1d65c26bb93"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd74b1403a2fecf21d5c971e3f3c806933f709ada16bbff2e932de2585a20874"
    sha256 cellar: :any,                 arm64_monterey: "6373237ca91cfb86b5e31a491d43fa55afef94379d9a847a9ad4f4d5ee3f52fc"
    sha256 cellar: :any,                 arm64_big_sur:  "171fb15a9d6d76cd2eddd244d687c403e66f291adbe40e734c795069e618f0b0"
    sha256 cellar: :any,                 ventura:        "7aa823980c68d09760c99f771ad370e241c59db30f37af5a865635cd3804acf3"
    sha256 cellar: :any,                 monterey:       "aa0fa1418472627c5d00e1d9dcb3a63db243b27601d818fc0984bb121f1d8fce"
    sha256 cellar: :any,                 big_sur:        "2c9e14ab68ae0e0cdc7a3806d4d158f45883e07deb6489933c6df8fb8485b724"
    sha256 cellar: :any,                 catalina:       "9ff0bf8055f3d1d0170959cda2a294cc49701a42eba35176c0bac65e785e4207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77124341477a0c2b065dceb69c2f82bbd8829e9df1089b7d9b4130cb1fc64c4"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.11"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "PyQt6-3D" do
    url "https://files.pythonhosted.org/packages/6a/f7/55aa01d56d4c6c20374389fc400822eb9327298111ab891f20af3e786037/PyQt6_3D-6.4.0.tar.gz"
    sha256 "c5e8e2224b9d461fe21158040b4446b5fd82ae563c76a8943292abd887a02df1"
  end

  resource "PyQt6-Charts" do
    url "https://files.pythonhosted.org/packages/b3/b4/fb94c482644f4a0a8bbb4f785eeea46c1229adc4468fcc025194482011e7/PyQt6_Charts-6.4.0.tar.gz"
    sha256 "b46eb12840516a039c36f70bb3f8423337f98fde266b582cead4049b77b43f64"
  end

  resource "PyQt6-DataVisualization" do
    url "https://files.pythonhosted.org/packages/62/b1/cee46d028500e171e98b8893fcbd2671601044db3eeb911e360e04546d98/PyQt6_DataVisualization-6.4.0.tar.gz"
    sha256 "1f276ddb1e774859356a977aeb8196866e280b03d3e33c7760a1f188153ce0a8"
  end

  resource "PyQt6-NetworkAuth" do
    url "https://files.pythonhosted.org/packages/a0/1c/6042587ed1e934206f7a2498e73b18ed7fc598c717af0561c409eaa01bfd/PyQt6_NetworkAuth-6.4.0.tar.gz"
    sha256 "c16ec80232d88024b60d04386a23cc93067e5644a65f47f26ffb13d84dcd4a6d"
  end

  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/39/fc/f889254efda90418e367df28da9d14ac64ca19a9d93f44355d21ac562b0f/PyQt6_sip-13.4.0.tar.gz"
    sha256 "6d87a3ee5872d7511b76957d68a32109352caf3b7a42a01d9ee20032b350d979"
  end

  resource "PyQt6-WebEngine" do
    url "https://files.pythonhosted.org/packages/c1/54/80bebc08c537723a145442c3997bab122ebc8e540ae807f4291b2ce7f8bb/PyQt6_WebEngine-6.4.0.tar.gz"
    sha256 "4c71c130860abcd11e04cafb22e33983fa9a3aee8323c51909b15a1701828e21"
  end

  def python3
    "python3.11"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("PyQt6-sip").stage do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end

    resources.each do |r|
      next if r.name == "PyQt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "PyQt6-WebEngine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

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
  end
end
