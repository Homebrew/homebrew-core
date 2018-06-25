class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.402-with-extensions-src.tgz"
  sha256 "79d794636bdb7962b8aa7023aa9f01b3fc7bbbee333b544947f86451515d8ac3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff0119ff36cfdc7b40fad648d5f417a1ec59d50748bf21e18ee3a11dd37d4bf8" => :high_sierra
    sha256 "9ca6bfbdb2d1d95077e2963763f25c8e1e68147f88576eb3328176f31e047223" => :sierra
    sha256 "a5995ed3fff7986d3ee00401f81db8a9ae0412a75a4a457b459911c0fa64f831" => :el_capitan
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
