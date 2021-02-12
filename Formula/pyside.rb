class Pyside < Formula
  desc "Official Python bindings for Qt"
  homepage "https://wiki.qt.io/Qt_for_Python"
  url "https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.0.1-src/pyside-setup-opensource-src-6.0.1.tar.xz"
  sha256 "baac59a71d5d8d28badd4b484b3722500a6616684f932f0652b33a5b5feaf365"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-3.0-only"]

  livecheck do
    url "https://download.qt.io/official_releases/QtForPython/pyside6/"
    regex(%r{href=.*?PySide6[._-]v?(\d+(?:\.\d+)+)-src/}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_big_sur: "9d5453546a594dd0e7873628e5b39d712e5c233bcd5c30300ebca69bba5234b8"
    sha256 big_sur:       "de6776cd9bf4d54feaee3c83acec3de9aae517ac35297c4beb7c0d23e8a99d8a"
    sha256 catalina:      "179300a978bc575037dac68319cd1db18cdb4755382c7d2c46e8372a78276de3"
    sha256 mojave:        "17d79dc60d1f3fe413bc874f4f82535f7bfe9739af107525291cc4c5b5a5db06"
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
