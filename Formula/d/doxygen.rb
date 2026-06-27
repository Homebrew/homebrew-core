class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.17.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.17.0/doxygen-1.17.0.src.tar.gz"
  sha256 "fa4c3dd78785abc11ccc992bc9c01e7a8c3120fe14b8a8dfd7cefa7014530814"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "f7300b3bdd8a8220e964932b08cef4fe5e4e689ec4c2a80dd865e986bfeb8683"
    sha256 cellar: :any, arm64_sequoia: "615adfdacb9b083f90f0a9ed91cbf11296b1f538f69aafb528423b194e3a5fdd"
    sha256 cellar: :any, arm64_sonoma:  "98a9385f0827df88a9009d371784610cfd1e64fb8c2ea8b3c85de71d76155add"
    sha256 cellar: :any, sonoma:        "973d4bc27b8a9626279d3e66ebf0fb4d322440e3eabac90c885388cc673bdebe"
    sha256 cellar: :any, arm64_linux:   "aa3908c04fe32fc6f72130f455c64d94f640ed4047a15b22db049636b0f57329"
    sha256 cellar: :any, x86_64_linux:  "a21382ddddf927450b1729fe595a133d2490f177615fa87b037aa3a021970c1b"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "spdlog"

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build
  uses_from_macos "sqlite"

  def install
    # Remove bundled dependencies
    rm_r(%w[
      deps/fmt
      deps/spdlog
      deps/sqlite3
    ])

    args = %W[
      -DPython_EXECUTABLE=#{which("python3")}
      -Duse_sys_fmt=ON
      -Duse_sys_spdlog=ON
      -Duse_sys_sqlite3=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"doxygen", "-g"
    system bin/"doxygen", "Doxyfile"
  end
end
