class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.2-src/pyside-setup-opensource-src-5.15.2.tar.xz"
  sha256 "b306504b0b8037079a8eab772ee774b9e877a2d84bab2dbefbe4fa6f83941418"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "2da0d4e6f5578894be86e636e1c3e38c77d55fa822de1e8af8452568aaf3d521"
    sha256 cellar: :any, arm64_big_sur:  "dea3a094619f3dd87bc875b261b837b5a9740307c17b708f770d27186d91e402"
    sha256 cellar: :any, big_sur:        "92f859236a4a544d67d7156393e43f74e525936193fe4cbd78efce08b182f950"
    sha256 cellar: :any, catalina:       "9910767e2fa6ae3e532e227d68e616deab536c9053f45027b3d3cb701816f67b"
    sha256 cellar: :any, mojave:         "ba4fe20995f6d18ebd36773e2eefc67e83c165db8e78283599301bf66ed37426"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt@5"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}
      -GNinja
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python#{xy}
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja", "install"
    end
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{lib}/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide2"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import shiboken2"

    modules = %w[
      Core
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ]

    # QT web engine is currently not supported on Apple
    # silicon. Re-enable it once it has been enabled in the qt.rb.
    modules << "WebEngineWidgets" unless Hardware::CPU.arm?

    modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide2.Qt#{mod}" }

    pyincludes = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --includes").chomp.split
    pylib = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(Formula["python@3.9"].opt_bin/"python3").to_s.delete(".")

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken2"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
           "-I#{include}/shiboken2", "-L#{lib}", "-lshiboken2.cpython-#{pyver}-darwin",
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
