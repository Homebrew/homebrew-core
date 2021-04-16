class Pyqt3d < Formula
  desc "Python bindings for The Qt Company’s Qt 3D framework"
  homepage "https://www.riverbankcomputing.com/software/pyqt3d/"
  url "https://files.pythonhosted.org/packages/86/a8/91f76584146250da04d9f2c33355a119279928ed8cfc04a8b1baf9c2c667/PyQt6_3D-6.0.3.tar.gz"
  sha256 "6981d25d7fe850a036d75c0fb1eb58331d7e1c51eda305b40081d1d2c4db0e82"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_big_sur: "f7590022b8a3eb011743eb067338922efc5d63869304d496786f906eacf4c705"
    sha256 big_sur:       "c71968e68258d734b2167e05067342b4ce58716434a19ca26f2880726b352521"
    sha256 catalina:      "6de6137c50a524ef598367c2850dd4cf05c519bbe0f98b66014ca965dd577d0f"
    sha256 mojave:        "3e937bc4e4c6f3d188f5ea8fb5eef6b8f6f39446d314e3e29e9f00fb28d6d38f"
  end

  depends_on "pyqt-builder" => :build

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  def install
    pyqt = Formula["pyqt"]
    python = Formula["python@3.9"]
    site_packages = Language::Python.site_packages(python)

    open("pyproject.toml", "a") do |f|
      f.puts <<~EOS
        [tool.sip.project]
        sip-include-dirs = ["#{pyqt.prefix/site_packages}/PyQt#{pyqt.version.major}/bindings"]
      EOS
    end

    system "sip-install", "--target-dir", prefix/site_packages
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
