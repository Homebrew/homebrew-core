class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/29/4c/2f98c98536b957117ac02c3ffe027c3a66937c027f6b3506d6dd4aca3389/PyQt6-6.0.3.tar.gz"
  sha256 "bfe5946a667080f7f755fb5acb92706c3e029bf7679d77fc3898f900f69f768a"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 arm64_big_sur: "61444a7551a7bddf664aab92a43cfeecb59f050a9fe80d0822843ca5ec432bef"
    sha256 big_sur:       "e175afb8de06d947e4926bcea2590acd41c8a763353863d92895a226588ca44f"
    sha256 catalina:      "fddc360c28607fca03d74f6cc091f958a2243f34b9aeb1888c055df7712fea0c"
    sha256 mojave:        "cdb9e6b67c56f66953beae5c5882bd718dfdf17c7a77036d7aadf3c86a4f676d"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip" => :build

  depends_on "python@3.9"
  depends_on "qt"

  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/95/7e/495d128a62a9f03bbfd71d764baccd44699cdcdeedb8db1dd4429e0646b2/PyQt6_sip-13.0.1.tar.gz"
    sha256 "310d0c0efdbc086ef913f4ecdfaf8e62f2b70cadeacb42536bfe943c19709987"
  end

  def install
    python = Formula["python@3.9"]
    site_packages = prefix/Language::Python.site_packages(python)
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("PyQt6-sip").stage do
      system python.bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

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
