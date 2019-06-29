class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_4_0.tar.gz"
  sha256 "d932b292f83371c7518960b2135c7a5b931efb43cdd8720e0b27268a698973e4"

  bottle do
    sha256 "bcd84fb95f1ce06d8073e1ea0ebbc0f7ff6399af21b4249e012edbab1bdb528b" => :mojave
    sha256 "edd23b3384f3efeb0aaeccf672d082cd727d73b4fc3d1adb6d1762f064966509" => :high_sierra
    sha256 "5230aab2724b2a0deac3b39adaa8a79092974f11ab0a90ffd5bc0bf785ccbc95" => :sierra
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
