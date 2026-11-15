class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://dev.opencascade.org/"
  url "https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_9_3.tar.gz"
  sha256 "5ecf094ec6b12d5413dfb851d8c3590c354058aee556e32e408bdfbf8c357d57"
  license "LGPL-2.1-only"
  revision 1
  compatibility_version 1

  # The first-party download page (https://dev.opencascade.org/release)
  # references version 7.5.0 and hasn't been updated for later maintenance
  # releases (e.g., 7.6.2, 7.5.2), so we check the Git tags instead. Release
  # information is posted at https://dev.opencascade.org/forums/occt-releases
  # but the text varies enough that we can't reliably match versions from it.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+(?:p\d+)?)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f3e8a4afb66a07801bd3977a165e9b897d4c49d3b65e41b556167ad1ff0b7cae"
    sha256 cellar: :any, arm64_tahoe:       "cbbb914aee6197f6ce60cf75b26e8b558be68699265c79cfe7e51e9713a10ea8"
    sha256 cellar: :any, arm64_sequoia:     "b62765e91c1b704cbee71297fc1901beb9db38d6a08d720735b490c10684b957"
    sha256 cellar: :any, arm64_linux:       "567e8bba26485d08562963d9c9870ccaeb691e1acbefb07ee2606ff88040ace2"
    sha256 cellar: :any, x86_64_linux:      "7118d9aee4489f4076b44ec19afa439de79466d5e4e96793467ed3bfb2b52e1d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "rapidjson" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "tbb"

  uses_from_macos "tcl-tk" # FIXME: TCL 9 causes segfaults in `f3d`

  on_linux do
    depends_on "libx11"
    depends_on "mesa" # For OpenGL
  end

  def install
    # FreeImage has multiple CVEs and has been dropped by distros like Arch Linux
    # Ref: https://archlinux.org/todo/drop-freeimage/
    odie "FreeImage should not be a dependency!" if deps.map(&:name).include?("freeimage")

    args = %W[
      -DUSE_FREEIMAGE=OFF
      -DUSE_RAPIDJSON=ON
      -DUSE_TBB=ON
      -DINSTALL_DOC_Overview=ON
      -DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF
      -D3RDPARTY_FREETYPE_DIR=#{formula_opt_prefix("freetype")}
      -D3RDPARTY_RAPIDJSON_DIR=#{formula_opt_prefix("rapidjson")}
      -D3RDPARTY_RAPIDJSON_INCLUDE_DIR=#{formula_opt_include("rapidjson")}
      -D3RDPARTY_TBB_DIR=#{formula_opt_prefix("tbb")}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    unless OS.mac?
      tcltk = Formula["tcl-tk"]
      libtk = tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major}tk#{tcltk.version.major_minor}")
      libtcl = tcltk.opt_lib/shared_library("libtcl#{tcltk.version.major_minor}")
      args += %W[
        -D3RDPARTY_TCL_DIR:PATH=#{tcltk.opt_prefix}
        -D3RDPARTY_TK_DIR:PATH=#{tcltk.opt_prefix}
        -D3RDPARTY_TCL_INCLUDE_DIR:PATH=#{tcltk.opt_include}/tcl-tk
        -D3RDPARTY_TK_INCLUDE_DIR:PATH=#{tcltk.opt_include}/tcl-tk
        -D3RDPARTY_TCL_LIBRARY_DIR:PATH=#{tcltk.opt_lib}
        -D3RDPARTY_TK_LIBRARY_DIR:PATH=#{tcltk.opt_lib}
        -D3RDPARTY_TCL_LIBRARY:FILEPATH=#{libtcl}
        -D3RDPARTY_TK_LIBRARY:FILEPATH=#{libtk}
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
      cmake_minimum_required(VERSION 4.0)
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
