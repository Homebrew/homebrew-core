class Fzy < Formula
  desc "Fast, simple fuzzy text selector with an advanced scoring algorithm."
  homepage "https://github.com/jhawthorn/fzy"
  url "https://github.com/jhawthorn/fzy/archive/0.9.tar.gz"
  sha256 "72182686806ddce7807d85c27efc321a1b01087643ce8006b1225e3617eecff5"
  head "https://github.com/jhawthorn/fzy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1831deb1a5de5c25a48d304dcecd34b87bd9dee67980ea7cbc343289d82a77f" => :sierra
    sha256 "88b4a4dd16289fc68a4205911e2a7a1d82ca25aafe1beef9a249c02787c28a98" => :el_capitan
    sha256 "a72164d23f90277c08c19617c57ddacf7c30dfc9751cc9428d2b1ffd8bd513df" => :yosemite
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fzy -e foo", "bar\nfoo\nqux").chomp
  end
end
