class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8e/a4/d5e4bf99dd50134c88b95e926d7b81aad2473b47fde5e3e4eac2c69a8942/PyQt5-5.15.4.tar.gz"
  sha256 "2a69597e0dd11caabe75fae133feca66387819fc9bc050f547e5551bce97e5be"
  license "GPL-3.0-only"

  depends_on "pyqt-builder" => :build
  depends_on "python@3.9"
  depends_on "qt@5"
  depends_on "sip"

  resource "PyQt5-sip" do
    url "https://files.pythonhosted.org/packages/73/8c/c662b7ebc4b2407d8679da68e11c2a2eb275f5f2242a92610f6e5024c1f2/PyQt5_sip-12.8.1.tar.gz"
    sha256 "30e944db9abee9cc757aea16906d4198129558533eb7fadbe48c5da2bd18e0bd"
  end

  def install
    python = Formula["python@3.9"]
    args = %W[
      --target-dir #{prefix}
      --no-make
      --confirm-license
      --no-designer-plugin
      --no-qml-plugin
    ]
    system "sip-build", *args
    cd "build" do
      system "make"
      inreplace "inventory.txt", python.opt_prefix, prefix
      inreplace "Makefile", /(?<=\$\(INSTALL_ROOT\))#{Regexp.escape(python.opt_prefix)}/, prefix
      system "make", "install"
    end

    xy = Language::Python.major_minor_version python.bin/"python3"
    (lib/"python#{xy}/site-packages").install %W[#{prefix}/PyQt#{version.major} #{prefix}/PyQt#{version.major}-#{version}.dist-info]

    resource("PyQt5-sip").stage do
      system python.bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{opt_lib}/python#{xy}/site-packages"
    system "#{bin}/pyuic#{version.major}", "--version"
    system "#{bin}/pylupdate#{version.major}", "-version"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{version.major}"
    %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
