class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8e/a4/d5e4bf99dd50134c88b95e926d7b81aad2473b47fde5e3e4eac2c69a8942/PyQt5-5.15.4.tar.gz"
  sha256 "2a69597e0dd11caabe75fae133feca66387819fc9bc050f547e5551bce97e5be"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "213f50aaf7e3d11d41799431b5303791114a158a0db6db0d6ea61e0410c6af16"
    sha256 cellar: :any, big_sur:       "fb6b6568ef31f8acf69288c2d2def7e919e2ea052b83abf2e35a2c0f439b0020"
    sha256 cellar: :any, catalina:      "b6be23fb0704f405dc3e09a3711629a145081e0adaec99c50f78c6e55971e8e2"
    sha256 cellar: :any, mojave:        "b86645249f0bf56ea3fcb9ae5738d32ad49d0974c2a78cd77ec0f7f99e6424b5"
  end

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
