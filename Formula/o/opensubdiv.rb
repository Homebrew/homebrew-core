class Opensubdiv < Formula
  desc "Open-source subdivision surface library"
  homepage "https://graphics.pixar.com/opensubdiv/docs/intro.html"
  url "https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v3_5_1.tar.gz"
  sha256 "42c7c89ffa552f37e9742d1ecfa4bd1d6a2892e01b68fc156775d104154d3d43"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9c6ad7c140280dedc0ada0800682cb8d5d355afcdc7e112beab09d7dacccf9f1"
    sha256 cellar: :any,                 arm64_monterey: "5c2327f25b985439c13f2a3336b00f899a676f713c5a3d955d7a4d2cddc3a5af"
    sha256 cellar: :any,                 arm64_big_sur:  "2355471b5a1fe15f3083feab03f0326baef2edaa1d8f19230a866819f80c4989"
    sha256 cellar: :any,                 ventura:        "5931a532b5f78cf0c0beb223ac144798d63d18e4b822a4ad4773513d59e0a1f1"
    sha256 cellar: :any,                 monterey:       "15fd118eba4ceac5ba401c4226eeb7ace629319f011e7e1e02e1de14a07651b3"
    sha256 cellar: :any,                 big_sur:        "bd387d91bf9f0543e74ab9a181808e6640a4bcedb54d0af991b1f2b50141f9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14a24f84173fa51e3ade65a2cacc4d1d919df865ed784e08084ede6f1bc9f31b"
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
