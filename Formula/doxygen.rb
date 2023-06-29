class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.7.repack.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.7/doxygen-1.9.7.repack.src.tar.gz"
  version "1.9.7"
  sha256 "aa9b2118578f4d277954c8584eb7228be47cdf29e8041ce4dcba21e41dfb89f3"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d43869a221c709c1b164fe38e08b73a99f861df61f80037508169a8f7b7d946a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7011815f4862e0d639282be742d26993f6b1c09075370e00a3be8e0d882b91c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "754f9c2e29bb0d0ed68c03a35657804d120653f29e70febae676e7e6e422c87a"
    sha256 cellar: :any_skip_relocation, ventura:        "370eb5c5e2c1dab4519b8d1337c4126402ead836c08a9dd69ceee17d8cfc06b8"
    sha256 cellar: :any_skip_relocation, monterey:       "cd6247e728dd99dfc83699e83c0f556a6c4a0e03f9bf3918eee5e441f4591fdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "152f4ab38a79ede7265adfa2c5c9cf472698d4942386b233303718e746aef117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a70cd48366251e0d62e76a5f2b349f58d3fb12d6240af64f2b8a16d31f36d8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  fails_with :gcc do
    version "6"
    cause "Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-Dbuild_doc=1", *std_cmake_args
    man1.install buildpath.glob("build/man/*.1")
  end

  test do
    system bin/"doxygen", "-g"
    system bin/"doxygen", "Doxyfile"
  end
end
