class PysideAT2 < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-5.15.2-src/pyside-setup-opensource-src-5.15.2.tar.xz"
  sha256 "b306504b0b8037079a8eab772ee774b9e877a2d84bab2dbefbe4fa6f83941418"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    sha256 arm64_big_sur: "5aced351a80a5cba50bd77ea61917574f76f85a77169f84db1e4875ef0ca6f2b"
    sha256 big_sur:       "ef8e3252c1769370bee755084239dee8d18d93f048925134238a4e07c2ea51ae"
    sha256 catalina:      "19142ae6963b16b49aa167ea4b00e11a8c67b96fe240349f530398e2efec244a"
    sha256 mojave:        "ff42e63c6b33b3a2e27b86a7c78155f33e74aed7ed73ba60a6b32186f63d079f"
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
