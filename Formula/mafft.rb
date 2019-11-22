class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.429-with-extensions-src.tgz"
  sha256 "a939b153a5ebaa18a786ad0598ce11d177f4ccff698404a9f9686a38fc6ee67b"

  bottle do
    cellar :any_skip_relocation
    sha256 "34536c22532e7427b8170be99a4a566334df6e03b752d18d6a8be0eec6a31fba" => :catalina
    sha256 "8286d20021c84330602546f9bc7d12f3440b62cf4e41c53188ec4409608a759e" => :mojave
    sha256 "b7a38f20fb6fc2d10845b6605962cedc1f2dd952fd46bb420a13203b2873e632" => :high_sierra
    sha256 "39fe0fcdb27d0a2e358c3c9ea41d6f07bd169f228943bc37a1b3186f67833513" => :sierra
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
