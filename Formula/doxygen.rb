class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.2.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.2/doxygen-1.9.2.src.tar.gz"
  sha256 "060f254bcef48673cc7ccf542736b7455b67c110b30fdaa33512a5b09bbecee5"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b5b2de93ac8703785860bfaf3e14f3268a07dc29bac9def13172785bcac7c5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8e1ea1bb601d8cc7cd7cf66b67a544e9e5534c2793cee5ac90bef5d076ad1e5"
    sha256 cellar: :any_skip_relocation, catalina:      "10e13f7bf6977bee6487366b3fc1dc55b4c191d5d505cb816997838504b3e0a4"
    sha256 cellar: :any_skip_relocation, mojave:        "0422adc9bfa6e1558cdcca24f8f4266f0927cf4c10fe3e245fe8e3017a7717b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "271d0e58a246109803f08cb46a3f4a28092bdee17b7fa78b541f259554bb03a7"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

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
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
