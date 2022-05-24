class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_4_4.tar.gz"
  sha256 "20d49f80a2b778ad4d01f091ad88d8c2f91cf6c7363940c6213241ce6f1048fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ac8f662d7df872990f3991cf6207355daf6e2862e2a1e9865e8b983371277af"
    sha256                               arm64_big_sur:  "76d36c038038fd7008964ec8d06f36b2970e56deda06e35096ab59cf02e056d9"
    sha256 cellar: :any,                 monterey:       "184d1b6e702029e2009175da965fd1403e01a8182517fac423ca303c02025396"
    sha256                               big_sur:        "2e1d8e64192097735c133a6b8282c8d204e3955b9359a85b51b129c7c8d1efe6"
    sha256                               catalina:       "3c25d8912c5751dda7134cd15b6841acead81b1d86b017acdc4e89fab9527a9b"
    sha256                               mojave:         "f335e92fcfd6f03e1c7348dc28b221fd38dfcb0d1bd27c8c5270c711b3019561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1526f27e8ccf65a26bb4e69369abeb929ee7457f3db02237aabf1e80c1593254"
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
