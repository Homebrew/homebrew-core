class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/refs/tags/v3_7_0.tar.gz"
  sha256 "f843eb49daf20264007d807cbc64516a1fed9cdb1149aaf84ff47691d97491f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0008ddc2f7b700de6b4be9c40e34265cd286eb82e2c8f3dbd5644765c7ba7992"
    sha256 cellar: :any,                 arm64_sequoia: "b4330e55e4bc62714863e6d69ad3865e466fa91dd0eff7fab13bddc683c3afae"
    sha256 cellar: :any,                 arm64_sonoma:  "34a9b873da0935fc9cc0b68c4100c95bd1b23cc60b59672bb299ba2449b6f94f"
    sha256 cellar: :any,                 sonoma:        "1d441722962464d68ef89db0062fca468ba4e61ecfbb11192054947202aaa268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a10d139e39100f49e3a599fa968a5e3914d93c9e6ac86ba365ea5fe2116ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110adddf9314496f0f21654961e0a173e72bb02c3c18a50152ab7ceeef52b586"
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
