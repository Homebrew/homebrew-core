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
    sha256 cellar: :any,                 arm64_ventura:  "56bc5fd2f2e74ebc65e9af7efd89a3938c0995df1cf5d4cb94ab1950b92af4ab"
    sha256 cellar: :any,                 arm64_monterey: "287186903053056952e4b029928e103b39fc00e0e7b6a23bf7d928bad0da2c7a"
    sha256 cellar: :any,                 arm64_big_sur:  "ddd26f2a6264150e8492c1a49a1ab8d2d8f5227b227e33caa93978b7e807efbf"
    sha256 cellar: :any,                 ventura:        "05b200abbd128d7d35fed9e13ce823de14eecac1959a730de5bdbb4989a46bdd"
    sha256 cellar: :any,                 monterey:       "deccb0da4f528d76a0d4cb3896332b59814c284d669e8c58b2a3b091969af84d"
    sha256 cellar: :any,                 big_sur:        "8b503e71b3c7c1f89e2a27ae53a43f146013152a84b36ef2131bd689b3e080bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14df8f0cc52d3ac661b2a9e5167fb67c116ebb8fb4da01abd9d9a2fe073db203"
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
  end
end
