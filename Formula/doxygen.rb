class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.5.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.5/doxygen-1.9.5.src.tar.gz"
  sha256 "55b454b35d998229a96f3d5485d57a0a517ce2b78d025efb79d57b5a2e4b2eec"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706295db97e997ee39e85d38359d95c7a8d661fd8ebe8f3da6389eabefa598f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88678e1605915b1ef739b2263478f2c959b3fa4c1fd149d162a5002d3c1b4dd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45b5114fd928094d087064d9970f55bf7e82bda660ec87a5de3746cc3e2e0ff7"
    sha256 cellar: :any_skip_relocation, ventura:        "384acd3b55b87a1582e788fc71ec54ecaadb23a652fa97c04da53d14b09df7dc"
    sha256 cellar: :any_skip_relocation, monterey:       "1d601108785ac9543bd7708aa2f13707f8d76efdf40211088dedcd187d6eff3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "15785c8a4a783c3d12623b2a2658d396bbc4abff2bc828be649c06205e38b850"
    sha256 cellar: :any_skip_relocation, catalina:       "4b030d959ff7d9cbf77aa105f7e8e70ce4b3d6dfb61073850e591d24bba68556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f9757ba4b568e9285707c59ff5ea3894bab08ecaada970a62347f6be69844f"
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
