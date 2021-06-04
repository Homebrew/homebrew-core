class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/64/be/d2b48e53d5767f25d607fa5a598e2af6ef9e1e8475bd6bfc60b27a5f34ea/PyQt6-6.1.0.tar.gz"
  sha256 "9b45df6c404d7297598b91378d1e3f9bdf0970553ebb53c192a9051576098f9b"
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
    url "https://files.pythonhosted.org/packages/f7/06/6a2d193f36d2f115fcfaac6375f05737270bc8c133cd259a7a3431c38152/PyQt6_3D-6.1.0.tar.gz"
    sha256 "8f04ffa5d8ba983434b0b12a63d06e8efab671a0b2002cee761bbd0ef443513c"
  end

  resource "charts" do
    url "https://files.pythonhosted.org/packages/bd/d3/3c5ddec0e55f0776aa4d975574805c8035fa180458c902d0d1912c9f4094/PyQt6_Charts-6.1.0.tar.gz"
    sha256 "46c83c1bf044c3d86cdc38c2eb37168432e0cc877e54fc3522af11f00021a7f4"
  end

  resource "datavis" do
    url "https://files.pythonhosted.org/packages/90/38/32971bd2b41a29f80aff5571ea68bb4a42c6b3fd58110f116ec05eb596a9/PyQt6_DataVisualization-6.1.0.tar.gz"
    sha256 "8d259abe586efcc970b606c167900e98847ed47b5b63fa0673758f7c9829cf2f"
  end

  resource "networkauth" do
    url "https://files.pythonhosted.org/packages/92/3d/3088bcf0bcba3b586c401dad60f7706224966e8861653088e5786115f66c/PyQt6_NetworkAuth-6.1.0.tar.gz"
    sha256 "11af1bb27a6b3686db8770cd9c089be408d4db93115ca77600e6c6415e3d318c"
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
