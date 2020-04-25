class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.464-with-extensions-src.tgz"
  sha256 "ca080cfc8a2c90bf1cb0b6d3e5f0e5e8ed294bcffa1764456abf279f36a3843f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6e8372f6e89a3001926a1f11acdba06c1d5ecf6ee42d5ad9a6be7692147fc77" => :catalina
    sha256 "3253fc686c81f566361935088acd1cdf7c2493f81233520a40eedeb8db9dbe10" => :mojave
    sha256 "eb7f34ff0a6015a18a71cc84c5d7839644166e0e3439201e66454e0337e871be" => :high_sierra
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
