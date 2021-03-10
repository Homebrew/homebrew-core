class Pyqt3d < Formula
  desc "Python bindings for The Qt Company’s Qt 3D framework"
  homepage "https://www.riverbankcomputing.com/software/pyqt3d/"
  url "https://files.pythonhosted.org/packages/98/f7/74014643c22166277ca46056afb262828a1fbc88933c20a3bb5dca393641/PyQt6_3D-6.0.2.tar.gz"
  sha256 "fb797dda5571e169edf60a0fd1443fac0907fb1f147339dbfdcd4a671106a876"
  license "GPL-3.0-only"

  depends_on "pyqt-builder" => :build

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  def install
    pyqt = Formula["pyqt"]
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    inreplace "pyproject.toml", "[tool.sip.project]", <<~EOS
      [tool.sip.project]
      sip-include-dirs = ["#{pyqt.opt_lib}/python#{xy}/site-packages/PyQt#{pyqt.version.major}/bindings"]
    EOS
    system "sip-install", "--target-dir", prefix
    (lib/"python#{xy}/site-packages").install %W[#{prefix}/PyQt#{pyqt.version.major} #{prefix}/PyQt#{pyqt.version.major}_3D-#{version}.dist-info]
  end

  test do
    pyqt = Formula["pyqt"]
    python = Formula["python@3.9"]
    %w[
      Animation
      Core
      Extras
      Input
      Logic
      Render
    ].each { |mod| system python.bin/"python3", "-c", "import PyQt#{pyqt.version.major}.Qt3D#{mod}" }
  end
end
