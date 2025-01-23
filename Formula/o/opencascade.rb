class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://dev.opencascade.org/"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_8_1;sf=tgz"
  version "7.8.1"
  sha256 "33f2bdb67e3f6ae469f3fa816cfba34529a23a9cb736bf98a32b203d8531c523"
  license "LGPL-2.1-only"
  revision 1

  # The first-party download page (https://dev.opencascade.org/release)
  # references version 7.5.0 and hasn't been updated for later maintenance
  # releases (e.g., 7.6.2, 7.5.2), so we check the Git tags instead. Release
  # information is posted at https://dev.opencascade.org/forums/occt-releases
  # but the text varies enough that we can't reliably match versions from it.
  livecheck do
    url "https://git.dev.opencascade.org/repos/occt.git"
    regex(/^v?(\d+(?:[._]\d+)+(?:p\d+)?)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b595733f44fc4274d778db8b823a084c8c7db25340e379f9576a459ced632d7"
    sha256 cellar: :any,                 arm64_sonoma:  "50d193d6a0919f8f5cd3b015a76093c29a18d2400fcfb87ef1452dde71650dae"
    sha256 cellar: :any,                 arm64_ventura: "0dbe2be098a5fcc4e0a23bd40885510a28a5121361668ebe0c53ccf3aac26ee9"
    sha256 cellar: :any,                 sonoma:        "5d9d9858f837687cc5500eb05db8792b37cb31711deb7c5ef43bab7c13f876d0"
    sha256 cellar: :any,                 ventura:       "077de8a6d15b74ace2cceaf344a6b3e2251df03d0e84bbee6b4ccf677d560b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c10e9c2b101c131e968115e39ba3ae20aa35559f8e2adce8ee7b809c4624444"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "rapidjson" => :build
  depends_on "fontconfig"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "tbb"
  depends_on "tcl-tk@8" # TCL 9 issue: https://tracker.dev.opencascade.org/view.php?id=33725

  on_linux do
    depends_on "libx11"
    depends_on "mesa" # For OpenGL
  end

  # Backport fix for incorrect type
  patch do
    url "https://github.com/Open-Cascade-SAS/OCCT/commit/7236e83dcc1e7284e66dc61e612154617ef715d6.patch?full_index=1"
    sha256 "ed8848b3891df4894de56ae8f8c51f6a4b78477c0063d957321c1cace4613c29"
  end

  def install
    tcltk = Formula["tcl-tk@8"]
    libtcl = tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")
    libtk = tcltk.opt_lib/shared_library("libtk#{tcltk.version.major_minor}")

    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_FREEIMAGE=ON",
                    "-DUSE_RAPIDJSON=ON",
                    "-DUSE_TBB=ON",
                    "-DINSTALL_DOC_Overview=ON",
                    "-DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF",
                    "-D3RDPARTY_FREEIMAGE_DIR=#{Formula["freeimage"].opt_prefix}",
                    "-D3RDPARTY_FREETYPE_DIR=#{Formula["freetype"].opt_prefix}",
                    "-D3RDPARTY_RAPIDJSON_DIR=#{Formula["rapidjson"].opt_prefix}",
                    "-D3RDPARTY_RAPIDJSON_INCLUDE_DIR=#{Formula["rapidjson"].opt_include}",
                    "-D3RDPARTY_TBB_DIR=#{Formula["tbb"].opt_prefix}",
                    "-D3RDPARTY_TCL_DIR:PATH=#{tcltk.opt_prefix}",
                    "-D3RDPARTY_TK_DIR:PATH=#{tcltk.opt_prefix}",
                    "-D3RDPARTY_TCL_INCLUDE_DIR:PATH=#{tcltk.opt_include}/tcl-tk",
                    "-D3RDPARTY_TK_INCLUDE_DIR:PATH=#{tcltk.opt_include}/tcl-tk",
                    "-D3RDPARTY_TCL_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TK_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TCL_LIBRARY:FILEPATH=#{libtcl}",
                    "-D3RDPARTY_TK_LIBRARY:FILEPATH=#{libtk}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The soname / install name of libtbb and libtbbmalloc are versioned only
    # by the minor version (e.g., `libtbb.so.12`), but Open CASCADE's CMake
    # config files reference the fully-versioned filenames (e.g.,
    # `libtbb.so.12.11`).
    # This mandates rebuilding opencascade upon tbb's minor version updates.
    # To avoid this, we change the fully-versioned references to the minor-only
    # version. For example:
    #   libtbb.so.12.11 => libtbb.so.12
    #   libtbbmalloc.so.2.11 => libtbbmalloc.so.2
    #   libtbb.12.11.dylib => libtbb.12.dylib
    #   libtbbmalloc.2.11.dylib => libtbbmalloc.2.dylib
    # See also:
    #   https://github.com/Homebrew/homebrew-core/issues/129111
    #   https://dev.opencascade.org/content/cmake-files-macos-link-non-existent-libtbb128dylib
    tbb_regex = /
      libtbb
      (malloc)? # 1
      (\.so)? # 2
      \.(\d+) # 3
      \.(\d+) # 4
      (\.dylib)? # 5
    /x
    inreplace (lib/"cmake/opencascade").glob("*.cmake") do |s|
      s.gsub! tbb_regex, 'libtbb\1\2.\3\5', audit_result: false
    end

    bin.env_script_all_files(libexec, CASROOT: prefix)

    # Some apps expect resources in legacy ${CASROOT}/src directory
    prefix.install_symlink pkgshare/"resources" => "src"
  end

  test do
    output = shell_output("#{bin}/DRAWEXE -b -c \"pload ALL\"")

    # Discard the first line ("DRAW is running in batch mode"), and check that the second line is "1"
    assert_equal "1", output.split("\n", 2)[1].chomp

    # Make sure hardcoded library name references in our CMake config files are valid.
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      set(CMAKE_CXX_STANDARD 11)
      project(test LANGUAGES CXX)
      find_package(OpenCASCADE REQUIRED)
      add_executable(test main.cpp)
      target_include_directories(test SYSTEM PRIVATE "${OpenCASCADE_INCLUDE_DIR}")
      target_link_libraries(test PRIVATE TKernel)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <Quantity_Color.hxx>
      #include <Standard_Version.hxx>
      #include <iostream>
      int main() {
        Quantity_Color c;
        std::cout << "OCCT Version: " << OCC_VERSION_COMPLETE << std::endl;
        return 0;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    ENV.append_path "LD_LIBRARY_PATH", lib if OS.linux?
    assert_equal "OCCT Version: #{version}", shell_output("./build/test").chomp
  end
end
