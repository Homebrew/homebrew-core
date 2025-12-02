class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz"
  sha256 "dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d"
  license "GPL-3.0-only"
  revision 5

  # The downloads page also lists pre-release versions, which use the same file
  # name format as stable versions. The only difference is that files for
  # stable versions are kept in corresponding version subdirectories and
  # pre-release files are in the parent QScintilla directory. The regex below
  # omits pre-release versions by only matching tarballs in a version directory.
  livecheck do
    url "https://www.riverbankcomputing.com/software/qscintilla/download"
    regex(%r{href=.*?QScintilla/v?\d+(?:\.\d+)+/QScintilla(?:[._-](?:gpl|src))?[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4ce4700e5e688b9b0b60890459a3793fc53e8cbaf27884f9ba88e94fa719515"
    sha256 cellar: :any,                 arm64_sequoia: "27499e5e9430c801ac7265f06845ccc56d6669f1626fab44a16f1b7aec80d61b"
    sha256 cellar: :any,                 arm64_sonoma:  "02d7ea7c1097a24289133b376012cc1592b395c6dd6bae358491de18a2c89d0d"
    sha256 cellar: :any,                 sonoma:        "d31a27c30e7b08f0635bb310d7f585de74a99d41f31705cb3ab3bf6b9f921cdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72fdcaf8876a39d1d6f68eb1cc46377fb444d4850fdec6e86e7658a16579bff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "388eef42d4cde7ec7ebd053bea92d3fae910ba2aff0167644b0b14bc3428e28f"
  end

  depends_on "pyqt" => [:build, :test]
  depends_on "pyqt-builder" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "qtbase"

  def python3
    "python3.14"
  end

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
      system Formula["pyqt-builder"].opt_libexec/"bin/sip-install", *args
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

    system Formula["qtbase"].bin/"qmake"
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
