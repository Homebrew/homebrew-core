class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/refs/tags/v3_6_0.tar.gz"
  sha256 "bebfd61ab6657a4f4ff27845fb66a167d00395783bfbd253254d87447ed1d879"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "82514e22222203cd7f1311d3e327cade6c43276a8824f86438fafe8bc14b8b33"
    sha256 cellar: :any,                 arm64_sonoma:   "0eedbb0c9de3bac83f8a80d501d6dc419942e8f09c4eecc5a49ce5dbb2243d64"
    sha256 cellar: :any,                 arm64_ventura:  "50e2cc8bbc3be3c7f3b507f4a65e75888c932ea97bee2a8478d8a71ff6f8726a"
    sha256 cellar: :any,                 arm64_monterey: "7d1d66be2ebc32bcb9479e69f329bd228ae2542233792d19bb26c1163dd3ef4a"
    sha256 cellar: :any,                 arm64_big_sur:  "1d94e5690cec6024c9bd13615a794ac68dc3a10119c80485df785515995125a7"
    sha256 cellar: :any,                 sonoma:         "f0fd75bc49465fe550a484cc1f24adeb18916eafaac7e63df182a5d5c27f7b43"
    sha256 cellar: :any,                 ventura:        "bc2da69a8b23d92d1e7101a48cc807064fd41a14cd6a8da1c940ae906106d048"
    sha256 cellar: :any,                 monterey:       "4f62d8949eeac18135b8e8a4de554a46dea88476283633085330856c8e034a7f"
    sha256 cellar: :any,                 big_sur:        "e895c57930e63805ce8493a73b83a3aaf92269fc5e9755234868a3aab2532cea"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e571546749c5a3bbd1b04aad99b75518e10d645e3829d2d392a5d3d16e0a183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce1c6ebb77690c1f20e601272430e50f0dbc21d7a8a8952a8f1b6ed0dffbd6c"
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
