class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://dev.opencascade.org/"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_6_1;sf=tgz"
  version "7.6.1"
  sha256 "c111c635fa4cae05821640f5afbbf362efaee8dc51fcbee953866eec7482cd6a"
  license "LGPL-2.1-only"

  # The first-party download page (https://dev.opencascade.org/release)
  # references version 7.5.0 and hasn't been updated for later maintenance
  # releases (e.g., 7.6.1, 7.5.2), so we check the Git tags instead. Release
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
    sha256 cellar: :any,                 arm64_monterey: "dce66270316070ee693c391fb5582af701b543d085cb1f51229103e11541a4e9"
    sha256 cellar: :any,                 arm64_big_sur:  "22b4d090a706334cbf99c2f37ea2057701b10c06b193984c2b1d86fbd5860497"
    sha256 cellar: :any,                 monterey:       "8cc2c94e0eba90f74648d876e9a4879e4b459d685b07d30892365a3f7610a5f2"
    sha256 cellar: :any,                 big_sur:        "e648acdcf39d6e3da6c3af8904a8d80fae9ad1201d55b75eb1e8058b0afa6f71"
    sha256 cellar: :any,                 catalina:       "aa3035c445f7d9f746a75494945b0c50aa1a8aaacf1b00c5d200090e9ee55108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0284917e0d46ff89e1f084082012b168458e632da37be0dd341dff38f95af4"
  end

  depends_on "cmake" => :build
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

  # Fix compilation errors with oneTBB 2021
  # Issue ref: https://tracker.dev.opencascade.org/view.php?id=0032697
  patch do
    url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=patch;h=740833a6a88e481f474783c426b6f6311ed586d3"
    sha256 "04932bf0674906dbc8f9c4ff0702aad3147c5db9abd0262973e18a1e4cd73976"
  end

  def install
    tcltk = Formula["tcl-tk"]
    system "cmake", ".",
                    "-DUSE_FREEIMAGE=ON",
                    "-DUSE_RAPIDJSON=ON",
                    "-DUSE_TBB=ON",
                    "-DINSTALL_DOC_Overview=ON",
                    "-D3RDPARTY_FREEIMAGE_DIR=#{Formula["freeimage"].opt_prefix}",
                    "-D3RDPARTY_FREETYPE_DIR=#{Formula["freetype"].opt_prefix}",
                    "-D3RDPARTY_RAPIDJSON_DIR=#{Formula["rapidjson"].opt_prefix}",
                    "-D3RDPARTY_RAPIDJSON_INCLUDE_DIR=#{Formula["rapidjson"].opt_include}",
                    "-D3RDPARTY_TBB_DIR=#{Formula["tbb"].opt_prefix}",
                    "-D3RDPARTY_TCL_DIR:PATH=#{tcltk.opt_prefix}",
                    "-D3RDPARTY_TK_DIR:PATH=#{tcltk.opt_prefix}",
                    "-D3RDPARTY_TCL_INCLUDE_DIR:PATH=#{tcltk.opt_include}",
                    "-D3RDPARTY_TK_INCLUDE_DIR:PATH=#{tcltk.opt_include}",
                    "-D3RDPARTY_TCL_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TK_LIBRARY_DIR:PATH=#{tcltk.opt_lib}",
                    "-D3RDPARTY_TCL_LIBRARY:FILEPATH=#{tcltk.opt_lib}/libtcl#{tcltk.version.major_minor}.dylib",
                    "-D3RDPARTY_TK_LIBRARY:FILEPATH=#{tcltk.opt_lib}/libtk#{tcltk.version.major_minor}.dylib",
                    "-DCMAKE_INSTALL_RPATH:FILEPATH=#{lib}",
                    *std_cmake_args
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", CASROOT: prefix)

    # Some apps expect resources in legacy ${CASROOT}/src directory
    prefix.install_symlink pkgshare/"resources" => "src"
  end

  test do
    output = shell_output("#{bin}/DRAWEXE -b -c \"pload ALL\"")

    # Discard the first line ("DRAW is running in batch mode"), and check that the second line is "1"
    assert_equal "1", output.split(/\n/, 2)[1].chomp
  end
end
