class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.7.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.7/doxygen-1.9.7.src.tar.gz"
  sha256 "87007641c38e2c392c8596f36711eb97633b984c8430f389e7bcf6323a098d94"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38c50ba54043e382d4cbf3934d509afba782679dc7cf31069f7196537b770ebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "052d0b10aa0fc3f8f8f1ab0ae31f8bccec63858b1a9a626807d1cf0ed65c1cc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4efff146171258f9a93fda043a66888bcf7ff8716ae62b1cd185d0a5679480a3"
    sha256 cellar: :any_skip_relocation, ventura:        "c53fb8c6caee92b7881ac4594308c91b6d89957a1a8ba7366391859bc968b2e4"
    sha256 cellar: :any_skip_relocation, monterey:       "3deddf4758227ef1a5fd20fc221202d136a4f034d969d93e656ce0443e3de892"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7435815e14c2f35537a83cce6197dbc8a0f1026e601355d43054024b2d48774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b5c6eb08447e2b762210f9481fa3932110509cc3467730aa81426327623d14a"
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
