class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_4_0.tar.gz"
  sha256 "d932b292f83371c7518960b2135c7a5b931efb43cdd8720e0b27268a698973e4"

  bottle do
    sha256 "ff26ccfc7953b18c7117db84a8f73dfbc10511d9b49b90ff143b743970cb3e01" => :mojave
    sha256 "13f2a6fe7993bb82da70c2a249c634c5526cbf29cf7bdaf844d52476b1f06c61" => :high_sierra
    sha256 "dc5485a6f2df692a6c64e88cac96b98fc4fc8c85de3aa7517410190133433ace" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  def install
    glfw = Formula["glfw"]
    args = std_cmake_args + %W[
      -DNO_CLEW=1
      -DNO_CUDA=1
      -DNO_DOC=1
      -DNO_EXAMPLES=1
      -DNO_OMP=1
      -DNO_OPENCL=1
      -DNO_PTEX=1
      -DNO_TBB=1
      -DGLFW_LOCATION=#{glfw.opt_prefix}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      pkgshare.install bin/"tutorials/hbr_tutorial_0"
      rm_rf "#{bin}/tutorials"
    end
  end

  test do
    output = shell_output("#{pkgshare}/hbr_tutorial_0")
    assert_match "Created a pyramid with 5 faces and 5 vertices", output
  end
end
