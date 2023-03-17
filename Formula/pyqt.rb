class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/c3/e0/e1b592a6253712721612e2e64a323930a724e1f5cf297ed5ec6d6c86dda1/PyQt6-6.4.2.tar.gz"
  sha256 "740244f608fe15ee1d89695c43f31a14caeca41c4f02ac36c86dfba4a5d5813d"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a379bba6ad786d78ec55a868b410eb38022ed1674c2df50cde937f34623e705"
    sha256 cellar: :any,                 arm64_monterey: "0da5528f8ea30bd0850e9f8800d6a137edcb465dfae11820c53ea3c8a9fc0500"
    sha256 cellar: :any,                 arm64_big_sur:  "28ce8c847006c6f7e70a7790a72a6d0b44af08f3687225b84a2ec1a9a0588310"
    sha256 cellar: :any,                 ventura:        "29178ac8f60b7ff5acbf3ee0808817a5c7a7caa8b57d15c82e50f5100f76c7a4"
    sha256 cellar: :any,                 monterey:       "7dc408d797261fe6a3a16ae46b664579a28e038e0994a80dfa2b99670dbc8213"
    sha256 cellar: :any,                 big_sur:        "29304df6f202d700cfb4178e9b5cf320ebefe99363b05556ca68a06cecde250f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e7399c81154bf9fa334f3efadb10ca7aba75ba46e4d420e67accbc197fd5e9"
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
    url "https://files.pythonhosted.org/packages/1e/24/99d1f9938afd58cf2d6120454cb36214bd76e18443b130b80b09fb368579/PyQt6_sip-13.4.1.tar.gz"
    sha256 "e00e287ea05bbc293fc6e2198301962af9b7b622bd2daf4288f925a88ae35dc9"
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
