class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://ab.inf.uni-tuebingen.de/software/diamond/"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.13.tar.gz"
  sha256 "066d2744ef9e8f3d6f7eba5e6eb226434299b18574c8716bbdd8faca31b325de"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
