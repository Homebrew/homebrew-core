class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://dev.opencascade.org/"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_7_0;sf=tgz"
  version "7.7.0"
  sha256 "075ca1dddd9646fcf331a809904925055747a951a6afd07a463369b9b441b445"
  license "LGPL-2.1-only"

  # The first-party download page (https://dev.opencascade.org/release)
  # references version 7.5.0 and hasn't been updated for later maintenance
  # releases (e.g., 7.6.2, 7.5.2), so we check the Git tags instead. Release
  # information is posted at https://dev.opencascade.org/forums/occt-releases
  # but the text varies enough that we can't reliably match versions from it.
  livecheck do
    url "https://git.dev.opencascade.org/repos/occt.git"
    regex(/^v?(\d+(?:[._]\d+)+(?:p\d+)?)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("_", ".") }.compact
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0162e3ca23a6a457c27758d74d9d381977ce440db5b73691b9c64c9853ddeb9c"
    sha256 cellar: :any,                 arm64_monterey: "ea1fb9ba90f1f21e154831a34753c1224eb2fce1d28c8c6cd6327d8b6542167e"
    sha256 cellar: :any,                 arm64_big_sur:  "85e47fb1a77014a39be4883157c00a4c1396e15fc77fab2daacf9399885be447"
    sha256 cellar: :any,                 ventura:        "dcf19a023624080c74694edd1e8c0004726789711a5965b809ad09afee215a33"
    sha256 cellar: :any,                 monterey:       "8c4e6f43b96a47c0f150e2dc9f0a1d20f79036cff1ff84a2feebb054c15c040b"
    sha256 cellar: :any,                 big_sur:        "75ab9f445fd48c02bf5b0f4318337bcbd3a51d9d87ee0dcf1d4094a5c9efdc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f337ba6677432b4380ea30745a7b3eb5d343c24cf1fcb82c7387ee04b8d357"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "rapidjson" => :build
  depends_on "fontconfig"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "tbb"
  depends_on "tcl-tk"

  on_linux do
    depends_on "mesa" # For OpenGL
  end

  # Fix a missing <limits> header. Try removing on next release.
  patch do
    url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=patch;h=2a8c5ad46cfef8114b13c3a33dcd88a81e522c1e;hp=7ea3eff4f88640ca23e5b1a6dad82ab4fda4a8c6"
    sha256 "3aff4835faf75d7d48aaa53db88e00df527b65b0a930746e1b8d1534c9b368b1"
  end

  def install
    tcltk = Formula["tcl-tk"]
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

    bin.env_script_all_files(libexec, CASROOT: prefix)

    # Some apps expect resources in legacy ${CASROOT}/src directory
    prefix.install_symlink pkgshare/"resources" => "src"
  end

  test do
    output = shell_output("#{bin}/DRAWEXE -b -c \"pload ALL\"")

    # Discard the first line ("DRAW is running in batch mode"), and check that the second line is "1"
    assert_equal "1", output.split(/\n/, 2)[1].chomp

    # Make sure hardcoded library name references in our CMake config files are valid.
    # https://github.com/Homebrew/homebrew-core/issues/129111
    # https://dev.opencascade.org/content/cmake-files-macos-link-non-existent-libtbb128dylib
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
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
