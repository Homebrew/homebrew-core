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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e875587faa33f46794ca6136db98467b0370cf9f53b0b0e21750173406d04c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe575452298c3a909e67a1520bea557721c10f91e5afb4183ba013191f630449"
    sha256 cellar: :any_skip_relocation, monterey:       "c9d03661181e155cecfefc57c8b8a64d9e9ce7b48405ed417767f278f01cfbdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "88e4f8914454a343c5e7414069ed8a787192e2bb083f5b270d527611145d9a07"
    sha256 cellar: :any_skip_relocation, catalina:       "b80ace4ec3442d0098392f3eb3b526c51009da991ecd33b9260e4a3d3ddf7603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7ea1dc2dcf918fd884959b915f22b34bf3d0e7082a603604542bdbac9d8dda"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "python@3.10" => :build # Fails to build with macOS Python3
  uses_from_macos "flex" => :build, since: :big_sur

  # Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
