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
    sha256 cellar: :any,                 arm64_sonoma:   "6fb256991b510ff55552bc805e7044d3545d51398c938d62038ba32e79f9f8a5"
    sha256 cellar: :any,                 arm64_ventura:  "2e917a31f5e2041f0f410f6a28e7fd782a16b40610577decd1370a51affd3a6f"
    sha256 cellar: :any,                 arm64_monterey: "17dd75682a7d9a0ffbce7264c4c057ebedcd6cf13285fda299e9aae1dca82514"
    sha256 cellar: :any,                 sonoma:         "6ff12a8e9e5ca6dd65f70ab6932a03e73a2e234b7ac568485dff28d9f88c0112"
    sha256 cellar: :any,                 ventura:        "4252af7063d8286071bdf75a414636009b4ffa86b9fc750092bf80025bc8b86a"
    sha256 cellar: :any,                 monterey:       "9a0a71f39273141d7fce01ee4fa44bb447b81120605a6bcea671b20a482fb831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c584ef6e5420e8ac1cdc3fa3dcf9d34d3e2482e4ae1b0bdf08f23682c2fa7a"
  end

  depends_on "pyqt-builder" => :build
  depends_on "pyqt"
  depends_on "python@3.12"
  depends_on "qt"

  fails_with gcc: "5"

  def python3
    "python3.12"
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
      system Formula["pyqt-builder"].opt_libexec/"bin/sip-install", *args
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
