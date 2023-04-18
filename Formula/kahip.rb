class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.14.tar.gz"
  sha256 "9da04f3b0ea53b50eae670d6014ff54c0df2cb40f6679b2f6a96840c1217f242"
  license "MIT"
  revision 1
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b999a1be4898c4e40b9aff02b62146505db291dba06db771c238cb37490d1a5"
    sha256 cellar: :any,                 arm64_monterey: "caefdd4a209465343d4b986895d17278c811acd876f7ecce50388ab0c4e7b250"
    sha256 cellar: :any,                 arm64_big_sur:  "a393a6470d7569acf1c2e1e0b402d5901cea07c9880a7d6f01423acdaad7262a"
    sha256 cellar: :any,                 ventura:        "ae1e1f542691906b9321faa0ab5ff338cc3e2b87524fdc4a4e3cedb73c44d120"
    sha256 cellar: :any,                 monterey:       "8f147b571794bbc87b050e84edaca1eb90be0b7c3ed6f0976f3f22c7a6a6ed96"
    sha256 cellar: :any,                 big_sur:        "d6ef09d6bde208d85c59ea4d5748a0289a6eddec3e75315766a05e692b857c6d"
    sha256 cellar: :any,                 catalina:       "f3c5fee2f01f5d4dce03a9f5c43ec8bdb6ba2199aa199c0bb09eefcffe1cb425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6780ba35f379f397d06db1b6b6f5d1b4a236993959821400d94f5058b1686b83"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "needs OpenMP support"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
