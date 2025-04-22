class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz"
  sha256 "dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d"
  license "GPL-3.0-only"
  revision 4

  # The downloads page also lists pre-release versions, which use the same file
  # name format as stable versions. The only difference is that files for
  # stable versions are kept in corresponding version subdirectories and
  # pre-release files are in the parent QScintilla directory. The regex below
  # omits pre-release versions by only matching tarballs in a version directory.
  livecheck do
    url "https://www.riverbankcomputing.com/software/qscintilla/download"
    regex(%r{href=.*?QScintilla/v?\d+(?:\.\d+)+/QScintilla(?:[._-](?:gpl|src))?[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "eef138891327e8f9a5577972ee0c442ca7f3cf64c768541271418c0e577fbfae"
    sha256 cellar: :any,                 arm64_ventura: "19e9c2e210f487a2a54f800c56e0e7b06bfaddf9d5a68a6bc2b54782a4d0d902"
    sha256 cellar: :any,                 sonoma:        "62385ab067cc1fef525c0732f0b29b5044a2af79557bc49606a288b182b59a87"
    sha256 cellar: :any,                 ventura:       "8a875755a790c4d437e29e2f93d8257bc3feeb0e7e56d0ebc2227f532eec7608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d578937c4531c8cf6af62e88838e12e2431f46b042737da78841414a5c2fa92"
  end

  depends_on "pyqt-builder" => :build
  depends_on "pyqt"
  depends_on "python@3.13"
  depends_on "qt"

  def python3
    "python3.13"
  end

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    pyqt = Formula["pyqt"]
    qt = Formula["qt"]
    site_packages = Language::Python.site_packages(python3)

    cd "src" do
      inreplace "qscintilla.pro" do |s|
        s.gsub! "QMAKE_POST_LINK += install_name_tool -id @rpath/$(TARGET1) $(TARGET)",
                "QMAKE_POST_LINK += install_name_tool -id #{lib}/$(TARGET1) $(TARGET)"
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", share/"qt/translations"
        s.gsub! "$$[QT_INSTALL_DATA]", share/"qt"
        s.gsub! "$$[QT_HOST_DATA]", share/"qt"
      end

      inreplace "features/qscintilla2.prf" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
      end

      system qt.opt_bin/"qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    cd "Python" do
      mv "pyproject-qt#{qt.version.major}.toml", "pyproject.toml"
      (buildpath/"Python/pyproject.toml").append_lines <<~TOML
        [tool.sip.project]
        sip-include-dirs = ["#{pyqt.opt_prefix/site_packages}/PyQt#{pyqt.version.major}/bindings"]
      TOML

      args = %W[
        --target-dir #{prefix/site_packages}

        --qsci-features-dir #{share}/qt/mkspecs/features
        --qsci-include-dir #{include}
        --qsci-library-dir #{lib}
        --api-dir #{share}/qt/qsci/api/python
      ]
      system Formula["pyqt-builder"].opt_libexec/"bin/sip-install", *args
    end
  end

  test do
    pyqt = Formula["pyqt"]
    (testpath/"test.py").write <<~PYTHON
      import PyQt#{pyqt.version.major}.Qsci
      assert("QsciLexer" in dir(PyQt#{pyqt.version.major}.Qsci))
    PYTHON

    system python3, "test.py"
  end
end
