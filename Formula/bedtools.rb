class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.30.0.tar.gz"
  sha256 "c575861ec746322961cd15d8c0b532bb2a19333f1cf167bbff73230a7d67302f"
  license "MIT"

  bottle do
    cellar :any
    sha256 "6cc3f3e0e540b594a44a839d62fc4dbd4a75a92de660b83fdceba81fd0f7651c" => :big_sur
    sha256 "882d1ba4c75198623d0004751fcb3184ffdd458de21ee30eb8d0854381e179c4" => :arm64_big_sur
    sha256 "ccf7c496bef6f4504e099ff6dfd0a04a277fe3481dcf0c4cae5b50e605fe9329" => :catalina
    sha256 "86d19c05b45021f1eedbccd910d0e1401e7b2aa7552bdf5160e77d9bf42fd4a6" => :mojave
    sha256 "9f2a0e41c2463fef3092b57f0a6a888ef4f50be07fa8b78b3185d6e971bc920d" => :high_sierra
  end

  depends_on "python@3.9" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "python", "python3"

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
