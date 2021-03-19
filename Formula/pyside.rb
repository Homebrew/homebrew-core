class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.0.2-src/pyside-setup-opensource-src-6.0.2.tar.xz"
  sha256 "55e129e044770c173d64e0144c7754125e6ded4a13ee3c1629dd6ae2ffae5e05"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    sha256 arm64_big_sur: "239f99f9eaca9ba85a68a805eb5279738d08bd58d5512ebf8492df84e703ee22"
    sha256 big_sur:       "f6387aca1629b8cd43a4ddc95d309a94f8b7a6ee9cfd7c0decf11e924b73c427"
    sha256 catalina:      "4fce7c337eed79efd48ee860b2759fe3b31144dca5824e8c36d783ac4133657e"
    sha256 mojave:        "48aa2aee0d35ee4218560c63e6f34a9039a0f2a75e8363631be10c6600cfccc0"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"
  depends_on "python@3.9"
  depends_on "qt"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    args = std_cmake_args + %W[
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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import shiboken6"

    # TODO: add modules `Position`, `Multimedia`and `WebEngineWidgets` when qt6.2 is released
    # arm support will finish in qt6.1
    modules = %w[
      Core
      Gui
      Network
      Quick
      Svg
      Widgets
      Xml
    ]

    modules.each { |mod| system Formula["python@3.9"].opt_bin/"python3", "-c", "import PySide6.Qt#{mod}" }

    pyincludes = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --includes").chomp.split
    pylib = shell_output("#{Formula["python@3.9"].opt_bin}/python3-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(Formula["python@3.9"].opt_bin/"python3").to_s.delete(".")

    (testpath/"test.cpp").write <<~EOS
      #include <shiboken.h>
      int main()
      {
        Py_Initialize();
        Shiboken::AutoDecRef module(Shiboken::Module::import("shiboken6"));
        assert(!module.isNull());
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
           "-I#{include}/shiboken6", "-L#{lib}", "-lshiboken6.cpython-#{pyver}-darwin",
           *pyincludes, *pylib, "-o", "test"
    system "./test"
  end
end
