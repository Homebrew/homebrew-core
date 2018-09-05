class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.407-with-extensions-src.tgz"
  sha256 "1840b51a0b93f40b4d6076af996ee46396428d8dbaf7ba1d847abff9cb1463e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "60555a1114a810872d411452cc09a5614b9a59a228781a9b502f18b56d0047de" => :mojave
    sha256 "b9d448733821c30381607630d773547758b378697760b448cd177d3d19e7e9e2" => :high_sierra
    sha256 "29fcbb6f12a136d0638c00726813706491f6822f6f6bf1f73bd178198cbd7558" => :sierra
    sha256 "8a3bcbc305bf8d1c5aebe9e98e972c1050cbf10cc39669e0b33098045eab3557" => :el_capitan
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
