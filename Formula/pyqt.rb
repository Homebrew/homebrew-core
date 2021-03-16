class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/29/4c/2f98c98536b957117ac02c3ffe027c3a66937c027f6b3506d6dd4aca3389/PyQt6-6.0.3.tar.gz"
  sha256 "bfe5946a667080f7f755fb5acb92706c3e029bf7679d77fc3898f900f69f768a"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_big_sur: "23c1f68ec3d0ef27f80b5d8a5393beaea4de181e98e697fae3126e4e1befd08a"
    sha256 big_sur:       "859346fba309a2215e628612c1a73acb8ceed9260b1b50cb3e27086778a65ad1"
    sha256 catalina:      "b4addd472da0e2d50c0720db5875d887869a9672100309483933e55bea8a7861"
    sha256 mojave:        "97f06b498b40a0be5609cbfb673dcb0ec98a3fdab8a6e27a7169bfb2796a8fdc"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/95/7e/495d128a62a9f03bbfd71d764baccd44699cdcdeedb8db1dd4429e0646b2/PyQt6_sip-13.0.1.tar.gz"
    sha256 "310d0c0efdbc086ef913f4ecdfaf8e62f2b70cadeacb42536bfe943c19709987"
  end

  def install
    python = Formula["python@3.9"]
    args = %W[
      --target-dir #{prefix}
      --no-make
      --confirm-license
    ]
    system "sip-build", *args
    cd "build" do
      qt_prefix = Formula["qt"].prefix Formula["qt"].version
      inreplace "inventory.txt", python.opt_prefix, prefix
      inreplace "inventory.txt", qt_prefix, prefix
      inreplace "Makefile", /(?<=\$\(INSTALL_ROOT\))#{Regexp.escape(python.opt_prefix)}/, prefix
      inreplace "designer/Makefile", /(?<=\$\(INSTALL_ROOT\))#{Regexp.escape(qt_prefix)}/, prefix
      inreplace "qmlscene/Makefile", /(?<=\$\(INSTALL_ROOT\))#{Regexp.escape(qt_prefix)}/, prefix
      system "make", "install"
    end

    xy = Language::Python.major_minor_version python.bin/"python3"
    (lib/"python#{xy}/site-packages").install %W[#{prefix}/PyQt#{version.major} #{prefix}/PyQt#{version.major}-#{version}.dist-info]

    resource("PyQt6-sip").stage do
      system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system "#{bin}/pyuic#{version.major}", "-V"
    system "#{bin}/pylupdate#{version.major}", "-V"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}"
    # TODO: add additional libraries in future: Position, Multimedia
    %w[
      Gui
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
