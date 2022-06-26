class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.4.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.4/doxygen-1.9.4.src.tar.gz"
  sha256 "a15e9cd8c0d02b7888bc8356eac200222ecff1defd32f3fe05257d81227b1f37"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d519a71cb39a0ef6669c25647212c2d507fe4a4453578cb5c6b47fb47b27a4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7d9b5448dc1b307d0a1fb7acc333c85a1b396bffff63efd38b6521093649a23"
    sha256 cellar: :any_skip_relocation, monterey:       "6686c3d3196af1961b090f8154c814f23ecb00e5b5e989027680dfc76fb039d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8685288bb8ac004bc09b12e528da5830dc0c537988b7c21a3c6e9d6d297403cf"
    sha256 cellar: :any_skip_relocation, catalina:       "e5a6b086212fefe22c3b46ca489bb70a39c05f0944f6daf19dd96cefad243716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13499e73a508e226120c6c50273b1e2ce8463380339eda1e4c5b92950512cf7a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  # Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
      system "cmake", "-Dbuild_doc=1", "..", *std_cmake_args
      man1.install Dir["man/*.1"]
    end
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
