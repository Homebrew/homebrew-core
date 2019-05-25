class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://www.opencascade.com/content/overview"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_3_0p3;sf=tgz"
  version "7.3.0p3"
  sha256 "fbd46db3e75313131b88a606024ea4d4496c3c7f6e68c23988e9d3e673d4f21b"

  bottle do
    cellar :any
    sha256 "8427b4f13e30e4bf455b769b42375a50ff338a73b5d9b392bc054793ec3f2a16" => :mojave
    sha256 "ce9ba0fab8d9356eeb89b2cadfbdf0e00fcfb0fc4b03e08dc2c9a8e32e77e319" => :high_sierra
    sha256 "42fb6d39f4c069543762c68dbeb49c1114c123b716b9504cb333bd23308497c4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "gl2ps"
  depends_on "tbb"

  def install
    system "cmake", ".",
                    "-DUSE_FREEIMAGE=ON",
                    "-DUSE_GL2PS=ON",
                    "-DUSE_TBB=ON",
                    "-DINSTALL_DOC_Overview=ON",
                    "-D3RDPARTY_FREEIMAGE_DIR=#{Formula["freeimage"].opt_prefix}",
                    "-D3RDPARTY_FREETYPE_DIR=#{Formula["freetype"].opt_prefix}",
                    "-D3RDPARTY_GL2PS_DIR=#{Formula["gl2ps"].opt_prefix}",
                    "-D3RDPARTY_TBB_DIR=#{Formula["tbb"].opt_prefix}",
                    "-D3RDPARTY_TCL_DIR:PATH=#{MacOS.sdk_path_if_needed}/usr",
                    "-D3RDPARTY_TCL_INCLUDE_DIR=#{MacOS.sdk_path_if_needed}/usr/include",
                    "-D3RDPARTY_TK_INCLUDE_DIR=#{MacOS.sdk_path_if_needed}/usr/include",
                    *std_cmake_args
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", :CASROOT => prefix)

    # Some apps expect resources in legacy ${CASROOT}/src directory
    prefix.install_symlink pkgshare/"resources" => "src"
  end

  test do
    output = shell_output("#{bin}/DRAWEXE -c \"pload ALL\"")
    assert_equal "1", output.chomp
  end
end
