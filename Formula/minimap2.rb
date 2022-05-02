class Minimap2 < Formula
  desc "Versatile pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://lh3.github.io/minimap2"
  url "https://github.com/lh3/minimap2/archive/refs/tags/v2.24.tar.gz"
  sha256 "2e3264300661cf1fce6adabffe6970ec59d46f3e8150dd40fa4501ff4f6c0dbc"
  license "MIT"

  uses_from_macos "zlib"

  def install
    if Hardware::CPU.arm?
      system "make", "arm_neon=1", "aarch64=1"
    else
      system "make"
    end
    bin.install "minimap2"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/minimap2 -a MT-human.fa MT-orang.fa 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
