class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.429-with-extensions-src.tgz"
  sha256 "a939b153a5ebaa18a786ad0598ce11d177f4ccff698404a9f9686a38fc6ee67b"

  bottle do
    cellar :any_skip_relocation
    sha256 "444919693de650796a35685050a73a7a82f55c40a3a4b308c4168f3a0f6f460a" => :mojave
    sha256 "576f4d1f41f38e35e056b6636c3cfe02aa02201fc91f35e203c91d5e01f36cee" => :high_sierra
    sha256 "bc8ad1455186bdc677206d67da93024483358bea588e440a4a515cdfaf8b7e76" => :sierra
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
