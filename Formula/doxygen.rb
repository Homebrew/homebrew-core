class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.1.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.1/doxygen-1.9.1.src.tar.gz"
  sha256 "67aeae1be4e1565519898f46f1f7092f1973cce8a767e93101ee0111717091d1"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8e1ea1bb601d8cc7cd7cf66b67a544e9e5534c2793cee5ac90bef5d076ad1e5" => :big_sur
    sha256 "2b5b2de93ac8703785860bfaf3e14f3268a07dc29bac9def13172785bcac7c5f" => :arm64_big_sur
    sha256 "10e13f7bf6977bee6487366b3fc1dc55b4c191d5d505cb816997838504b3e0a4" => :catalina
    sha256 "0422adc9bfa6e1558cdcca24f8f4266f0927cf4c10fe3e245fe8e3017a7717b5" => :mojave
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

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
