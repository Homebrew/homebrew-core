class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://www.opencascade.com/content/overview"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_4_0;sf=tgz"
  version "7.4.0"
  sha256 "655da7717dac3460a22a6a7ee68860c1da56da2fec9c380d8ac0ac0349d67676"

  bottle do
    cellar :any
    sha256 "898bcef9febe46552afbae44b7ecb368d55dca623554ffb514b3c6c3f4ec18f5" => :catalina
    sha256 "b8d97444db998b3ba99c457d79574337261369645ab98d1f413f05e30440f619" => :mojave
    sha256 "deb791a34aa0bde90fea8690cac771a1245f224ed69836bbdd30779a69569f1c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "tbb"

  def install
    system "cmake", ".",
                    "-DUSE_FREEIMAGE=ON",
                    "-DUSE_TBB=ON",
                    "-DINSTALL_DOC_Overview=ON",
                    "-D3RDPARTY_FREEIMAGE_DIR=#{Formula["freeimage"].opt_prefix}",
                    "-D3RDPARTY_FREETYPE_DIR=#{Formula["freetype"].opt_prefix}",
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
