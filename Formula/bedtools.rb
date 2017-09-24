class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.26.0.tar.gz"
  sha256 "15db784f60a11b104ccbc9f440282e5780e0522b8d55d359a8318a6b61897977"
  head "https://github.com/arq5x/bedtools2.git"

  patch do
    url "https://github.com/arq5x/bedtools2/commit/c0b7d934cc61ad6c83eb3d99374263e7ec51722d.diff?full_index=1"
    sha256 "b37113ff55b916787f29c12dece8b7f4289de30427c3a22a8cb332aa32d936dd"
  end

  def install
    system "make"
    prefix.install "bin"
    doc.install %w[README.md RELEASE_HISTORY]
  end

  test do
    (testpath/"t.bed").write "c	1	5\nc	4	9"
    assert_equal "c	1	9\n", shell_output("#{bin}/bedtools merge -i t.bed")
  end
end
