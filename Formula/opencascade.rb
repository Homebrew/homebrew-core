class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://www.opencascade.com/content/overview"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_5_0;sf=tgz"
  version "7.5.0"
  sha256 "c8df7d23051b86064f61299a5f7af30004c115bdb479df471711bab0c7166654"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url "https://www.opencascade.com/content/latest-release"
    regex(/href=.*?opencascade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "d8da69190c25ca94d888b17dd46cdc90fb79379d22463366a4501c5d8e17d96d" => :big_sur
    sha256 "dff73d65e119f968e9f64a0da66fa31f4eb3e3b0cddd2241add58dfb3dd641a0" => :catalina
    sha256 "d55ddd954f14f50fe8fb4898fe17b0872a2a95a89fb15978585e01887d925915" => :mojave
    sha256 "c1b1f1c3b05082464df1e130e518b536857beb8a07dea5d1f43120826346d6f0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "tbb"
  depends_on "tcl-tk"

  def install
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
                    *std_cmake_args
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", CASROOT: prefix)

    # Some apps expect resources in legacy ${CASROOT}/src directory
    prefix.install_symlink pkgshare/"resources" => "src"
  end

  test do
    output = shell_output("#{bin}/DRAWEXE -c \"pload ALL\"")
    assert_equal "1", output.chomp
  end
end
