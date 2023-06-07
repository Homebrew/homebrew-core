class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_5_0.tar.gz"
  sha256 "8f5044f453b94162755131f77c08069004f25306fd6dc2192b6d49889efb8095"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57c75be298bb59fe44f68c707b74ad63b9c2f6877d492ff2a449c450e31c874a"
    sha256 cellar: :any,                 arm64_monterey: "55e4971fc63f46550a0e6ce5e2c28a7ea690500b3794a91b27b40a9c2b1d722c"
    sha256 cellar: :any,                 arm64_big_sur:  "5611125d1094c5fd95ddffadb9969ef9429827c06707d6538a25e664cea033a7"
    sha256 cellar: :any,                 ventura:        "b70e5062658748cf1266dda5e6231bd4545e4d43866c5d0462b8843629282745"
    sha256 cellar: :any,                 monterey:       "eb6089b7f26f5f1ebf0f5563d000ac557ed6d971229840ec97cd91ca258cfa3d"
    sha256 cellar: :any,                 big_sur:        "e6bae70b4bd8560798e75db3145625a1fc6d04d1d330ce69eb32a43fa3360ee7"
    sha256 cellar: :any,                 catalina:       "299153bc3c8d9836d5da04116de0fc37ec9ed8d18b7eb34b4a411d42d4f38056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "034c5adee4fdccbc45db5c84b74b72c2447dd84a85e713958eba8384c27ded62"
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
