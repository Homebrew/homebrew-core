class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://www.opensubdiv.org/"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/refs/tags/v3_8_0.tar.gz"
  sha256 "e5eab30a97c7cce6b5a9905ae488981759c3d86cbce01d58a6c75e1fd9857a2b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fd9df1b0dd9efd930ff813cb27a9f4ed307226e564f406982c23a60e4465aca9"
    sha256 cellar: :any, arm64_tahoe:       "17528f2329b0ffd0a2f4291835056536f9357b752e278a44c0930e2eb69f1497"
    sha256 cellar: :any, arm64_sequoia:     "6a86d1ae248449cd02249da79c79903b955ef759846ef706265a3e1bbbc9e41f"
    sha256 cellar: :any, arm64_linux:       "b3e947cbc26c44936701ca240271eb8415558e97437ac4e5e610db1fe0a73c10"
    sha256 cellar: :any, x86_64_linux:      "047da92192493df5cb2cfdcbdac29859e49bcca8ca39e4cd5fc7934683fbc647"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  deny_network_access!

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
