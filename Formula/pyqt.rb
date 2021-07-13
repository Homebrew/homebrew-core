class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/a0/07/0ae4f67768c1150af851572fae287aeaf956ed91b3b650b888a856274ae4/PyQt6-6.1.1.tar.gz"
  sha256 "8775244fa73f94bfe8ae7672b624e2a903a22bc35d7ea42dd830949e2f9e43c7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e7932ff8a349c6b277d82f30ad164c7635eaec0f8ea12b3413995ecd178eef34"
    sha256 cellar: :any, big_sur:       "770aca2a80b9a49f422c0503896f2647d2b07c60bf07621f1b776e1d0d122407"
    sha256 cellar: :any, catalina:      "5ae647f00f04a0af6152b4b21a6f6ba4b1cdb6a59f5b367e078ad6537093b4e8"
    sha256 cellar: :any, mojave:        "d597e31a5f10125702e49739f9128f90b4011d0e32dc4c9a0dbe143837cacfdd"
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
    url "https://files.pythonhosted.org/packages/ea/5e/4c954451984d00dfc051eab5c4b40453923a85f5a0dfa9678511d06eec5e/PyQt6_3D-6.1.1.tar.gz"
    sha256 "f0277c04ac62f065cdd3f740a2149d260a5909e51df9fbb63e5ed83cebbe44f4"
  end

  resource "charts" do
    url "https://files.pythonhosted.org/packages/b9/ac/9c545186f3125b0fb02359938bddde0167344f3d4e14aee17fa122b5287a/PyQt6_Charts-6.1.1.tar.gz"
    sha256 "258416a5c8148cc824dede64b37ede08f14e1f90ef7e3c11e411b1b03268fee2"
  end

  resource "datavis" do
    url "https://files.pythonhosted.org/packages/56/8d/ddf81fe59263a0855d58b9f91d957e0956f3ea0aab17f0433f5cc69d4e8e/PyQt6_DataVisualization-6.1.1.tar.gz"
    sha256 "d66f92b991468ac92d4a9391e41f6e544ec54fab3488db131287907397ac1baf"
  end

  resource "networkauth" do
    url "https://files.pythonhosted.org/packages/04/cc/6e60bbc105992a9c2a98bb9135987baa4f35b27593a5e3ebf7ac2728ce0c/PyQt6_NetworkAuth-6.1.1.tar.gz"
    sha256 "1590118cef920adcef55022246994d5dfcc64cb7504bdd17eac92ffeb4a21dbe"
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

    %w[3d charts datavis networkauth].each do |p|
      resource(p).stage do
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
    # TODO: add additional libraries in future: Position, Multimedia
    %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Network
      NetworkAuth
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
