class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz"
  sha256 "dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d"
  license "GPL-3.0-only"
  revision 6

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
    sha256 cellar: :any, arm64_golden_gate: "877b5c02e7140cb3e1e7d8a449bf49bb19909b16e3ddcfd46ed64f2d39c47cc4"
    sha256 cellar: :any, arm64_tahoe:       "877b5c02e7140cb3e1e7d8a449bf49bb19909b16e3ddcfd46ed64f2d39c47cc4"
    sha256 cellar: :any, arm64_sequoia:     "376d54ff3dfa2686a06955ea97c6a9fe611e3cabb15e8eeea6f80ed636f17221"
    sha256 cellar: :any, arm64_linux:       "6610f9fd5bebc718251f845b621d9c1fecc24bcd28220796aff629c0000f546e"
    sha256 cellar: :any, x86_64_linux:      "e514894167010803c915bf7a0ff518d6b7edae291d5586db81768380538369ba"
  end

  depends_on "pyqt" => [:build, :test]
  depends_on "pyqt-builder" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "qtbase"

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    pyqt = Formula["pyqt"]
    qt = Formula["qtbase"]
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
      system formula_opt_libexec("pyqt-builder")/"bin/sip-install", *args
    end
  end

  def caveats
    "You will need to `brew install pyqt` to use the Python bindings."
  end

  test do
    (testpath/"test.pro").write <<~QMAKE
      CONFIG += qscintilla2 sdk_no_version_check
      CONFIG -= app_bundle
      SOURCES = test.cpp
    QMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <QApplication>
      #include <Qsci/qsciscintilla.h>

      int main(int argc, char *argv[]) {
        QApplication app(argc, argv);
        QsciScintilla test;
        test.setText("homebrew");
        std::cout << test.text().toStdString();
        return 0;
      }
    CPP

    ENV.delete "CPATH" if OS.mac?
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system formula_opt_bin("qtbase")/"qmake"
    system "make"
    assert_equal "homebrew", shell_output("./test")

    pyqt = Formula["pyqt"]
    (testpath/"test.py").write <<~PYTHON
      import PyQt#{pyqt.version.major}.Qsci
      assert("QsciLexer" in dir(PyQt#{pyqt.version.major}.Qsci))
    PYTHON

    system python3, "test.py"
  end
end
