class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz"
  sha256 "dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d"
  license "GPL-3.0-only"
  revision 3

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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "62b11b73e1f2c7b9dbc85ea61504571e05bb7e7e4cb1c8c4ad1e402d573f887c"
    sha256 cellar: :any,                 arm64_ventura:  "554edeca7a68a9ac7e16a7c28355ee27aee4ec3001efe29a6fc6fda8e9f956b5"
    sha256 cellar: :any,                 arm64_monterey: "2471feb09b256bd5b0e847cce6b5291536380773b9b6f0d72577e3597300a4d0"
    sha256 cellar: :any,                 sonoma:         "824426310deab401b0af20fc45035ea788303532208a5fa64656b4a074f033a7"
    sha256 cellar: :any,                 ventura:        "2777660ed371b133d7ca1948bb438c5a695c20f1c282075222159ec1f7e71615"
    sha256 cellar: :any,                 monterey:       "0bb6440e93f8363d1dfde69b72124e24cffeaf3f4bcef36580e1e038eea7c8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116b23e1fce19896461513216aa2f7b7c59d127317ce5e23b85b5dec0ea473da"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip" => :build
  depends_on "pyqt"
  depends_on "python@3.12"
  depends_on "qt"

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    args = []

    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
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
      (buildpath/"Python/pyproject.toml").append_lines <<~EOS
        [tool.sip.project]
        sip-include-dirs = ["#{pyqt.opt_prefix/site_packages}/PyQt#{pyqt.version.major}/bindings"]
      EOS

      args = %W[
        --target-dir #{prefix/site_packages}

        --qsci-features-dir #{share}/qt/mkspecs/features
        --qsci-include-dir #{include}
        --qsci-library-dir #{lib}
        --api-dir #{share}/qt/qsci/api/python
      ]
      system "sip-install", *args
    end
  end

  test do
    pyqt = Formula["pyqt"]
    (testpath/"test.py").write <<~EOS
      import PyQt#{pyqt.version.major}.Qsci
      assert("QsciLexer" in dir(PyQt#{pyqt.version.major}.Qsci))
    EOS

    system python3, "test.py"
  end
end
