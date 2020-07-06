class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_4_3.tar.gz"
  sha256 "7b22eb27d636ab0c1e03722c7a5a5bd4f11664ee65c9b48f341a6d0ce7f36745"
  license "Apache-2.0"

  bottle do
    sha256 "ef8b813dc962503a90798c4327805730eb6eba3989dfa7a3a137ea6021777e56" => :catalina
    sha256 "8b00f0fe55b6163755170a122fa3dbceaf740fe806ae6b856a37cd7b5928a856" => :mojave
    sha256 "41f202b119fff15151d6d2c8259b71c94f9d129141fc16992e6b75552b0b1ec7" => :high_sierra
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
