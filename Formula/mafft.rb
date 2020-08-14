class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-164.tar.gz"
  version "8.2-164"
  sha256 "00005bf1fd97e1b06486b58c2716049d72838310f0810f65620b69e66d03c343"

  bottle do
    cellar :any_skip_relocation
    sha256 "47030809ef8372782fbf5770b2b95057f31bcbf81ead53cb06cb09e2ecbd2f87" => :catalina
    sha256 "f7820f8386beaa0b0bfcfccc75bea1563d3b5947e32a0aba5051edb621491026" => :mojave
    sha256 "a194f9f065024b846417688c2da31c22c058598880c4fb8ef5369e10299ecf2f" => :high_sierra
  end

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
