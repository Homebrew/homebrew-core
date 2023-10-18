class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz"
  sha256 "dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d"
  license "GPL-3.0-only"
  revision 2

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
    sha256 cellar: :any,                 arm64_sonoma:   "a33886535d1e56ddf77070b440f6dc10913c7a0e3c7bfbabb3194c4419614477"
    sha256 cellar: :any,                 arm64_ventura:  "b4fc34f2bf9994694a2bcc79186fcc3c63b2c76f3a8147183c5c3bf4429c3cf5"
    sha256 cellar: :any,                 arm64_monterey: "c6de8f883ab5941a03bd2bed30500ff4785bb4aaa5b19cebf205d56c08118df4"
    sha256 cellar: :any,                 arm64_big_sur:  "9623a679469c1803e948315ed0d34758d3bde435e1b232e6e2588076edbe4c92"
    sha256 cellar: :any,                 sonoma:         "2aed1edfe9a762195ffca12ce85a40e9b25187e6999b3b913fe0edba4c194320"
    sha256 cellar: :any,                 ventura:        "d6fd65f0cebf021208064ad096e3a6183a9d4a2b10a9d1e4e9376c4ffbcde767"
    sha256 cellar: :any,                 monterey:       "0c90e3302753557ce769634718bb8b3c083da16c8ca8694930cbb31beee2fd0d"
    sha256 cellar: :any,                 big_sur:        "2c769ed8817441f8a905b01b7463c48a84b3208b230ca72cbdc680548a6821ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22420bf92a32afdfeb6d489f1f683cecb411c62781312394e6efb20af8861210"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  # TODO: use qt when octave can migrate to qt6
  depends_on "pyqt@5"
  depends_on "python@3.11"
  depends_on "qt@5"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    args = []

    if OS.mac?
      # TODO: when using qt 6, modify the spec
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
    end

    pyqt = Formula["pyqt@5"]
    qt = Formula["qt@5"]
    site_packages = Language::Python.site_packages(python3)

    cd "src" do
      inreplace "qscintilla.pro" do |s|
        s.gsub! "QMAKE_POST_LINK += install_name_tool -id @rpath/$(TARGET1) $(TARGET)",
          "QMAKE_POST_LINK += install_name_tool -id #{lib}/$(TARGET1) $(TARGET)"
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        # TODO: use qt6 directory layout when octave can migrate to qt6
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", prefix/"trans"
        s.gsub! "$$[QT_INSTALL_DATA]", prefix/"data"
        s.gsub! "$$[QT_HOST_DATA]", prefix/"data"
        # s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", share/"qt/translations"
        # s.gsub! "$$[QT_INSTALL_DATA]", share/"qt"
        # s.gsub! "$$[QT_HOST_DATA]", share/"qt"
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

      # TODO: qt6 options
      # --qsci-features-dir #{share}/qt/mkspecs/features
      # --api-dir #{share}/qt/qsci/api/python
      args = %W[
        --target-dir #{prefix/site_packages}

        --qsci-features-dir #{prefix}/data/mkspecs/features
        --qsci-include-dir #{include}
        --qsci-library-dir #{lib}
        --api-dir #{prefix}/data/qsci/api/python
      ]
      system "sip-install", *args
    end
  end

  test do
    pyqt = Formula["pyqt@5"]
    (testpath/"test.py").write <<~EOS
      import PyQt#{pyqt.version.major}.Qsci
      assert("QsciLexer" in dir(PyQt#{pyqt.version.major}.Qsci))
    EOS

    system python3, "test.py"
  end
end
