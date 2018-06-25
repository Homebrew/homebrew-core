class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.402-with-extensions-src.tgz"
  sha256 "79d794636bdb7962b8aa7023aa9f01b3fc7bbbee333b544947f86451515d8ac3"

  bottle do
    cellar :any_skip_relocation
    sha256 "823d5ae47d74dae6111ccbfc2dcd55f0ea3bfc956611633734a3d8ac3ac004a5" => :high_sierra
    sha256 "966cfbb27be12a9d0fd0bda110fe112828225f5ebfc3b9eeb416314c97282ac1" => :sierra
    sha256 "ecba2c513890512392db67b4832d9f70d0ea7dd52db9832e7c508764a7d93c76" => :el_capitan
  end

  depends_on :macos => :lion

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
