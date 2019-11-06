class Fzy < Formula
  desc "Fast, simple fuzzy text selector with an advanced scoring algorithm"
  homepage "https://github.com/jhawthorn/fzy"
  url "https://github.com/jhawthorn/fzy/releases/download/1.0/fzy-1.0.tar.gz"
  sha256 "80257fd74579e13438b05edf50dcdc8cf0cdb1870b4a2bc5967bd1fdbed1facf"
  head "https://github.com/jhawthorn/fzy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d517947fe59a7b4c577245cc7f1e7124aa65dfb95ae67175e1ebf3d3d14ac35e" => :catalina
    sha256 "2f7d67a61ad3cf284ec15d95e2f5eedaf1cf0ecb63ea2a8994df9733160b3a2b" => :mojave
    sha256 "fb173da3b703940c9dd8c942ced0db3c068f544be59fb01ccfe835f566d13cef" => :high_sierra
    sha256 "b478e2604e81faf0a2e7278afe2f811ff1739528f246fcf2556e05a81f1d3435" => :sierra
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fzy -e foo", "bar\nfoo\nqux").chomp
  end
end
