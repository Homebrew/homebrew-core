class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/refs/tags/v3_6_1.tar.gz"
  sha256 "e9d99a480d80e999667643747c76eb0138d36c418fc154fd71b4bd65be103d52"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76b7b335ea8d9524e18dbbd21691858ad74d7d09ff8b5969d31e9ab44bfb9676"
    sha256 cellar: :any,                 arm64_sonoma:  "1223a31b57c67540fbad0f16064d5fda7706f3c3f57603e5eb02d4cc2c5573c6"
    sha256 cellar: :any,                 arm64_ventura: "0da10fc1cbe96db3262a162f9f4fe0cd85243292e1a1a602163cf7928f3b625e"
    sha256 cellar: :any,                 sonoma:        "579179a8c61cb33744c70242f32a94d782855a735dc4cbd9f8a1f892ff798f59"
    sha256 cellar: :any,                 ventura:       "eccd1656b2948e437acdb40da817aa0da08a2051f05efac4f24ff2ec6533da0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "315cd06874f5f2c2dc281e4e7d1c67913f308cca6e075fd93e1039c2eb6a7595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652cca3e70d8291e4f77fd43b1fdda740e492fe9f7d997c474557a21071e9933"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  def install
    glfw = Formula["glfw"]
    args = %W[
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install bin/"tutorials/hbr_tutorial_0"
    rm_r("#{bin}/tutorials")
  end

  test do
    output = shell_output("#{pkgshare}/hbr_tutorial_0")
    assert_match "Created a pyramid with 5 faces and 5 vertices", output
  end
end
