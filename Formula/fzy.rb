class Fzy < Formula
  desc "Fast, simple fuzzy text selector with an advanced scoring algorithm."
  homepage "https://github.com/jhawthorn/fzy"
  url "https://github.com/jhawthorn/fzy/archive/0.8.tar.gz"
  sha256 "44293ef6a33ef5c9400b9546c580170a2df0ac4342b8fe447cee2af35e241b89"
  head "https://github.com/jhawthorn/fzy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d03e1e8bcbc53e1b4f2dd8faa0352673bdf2e274db66d68d232bc8f031ef85c4" => :sierra
    sha256 "bbd94cfef33c2c30abe08fbeb6fc497d3c5a5ecbbc31b9f8b99a718b7ca4a735" => :el_capitan
    sha256 "5f48d3fb088a8d44a3e11cd2b35fb04745c24841c78b72d444fd74ccc4f45229" => :yosemite
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fzy -e foo", "bar\nfoo\nqux").chomp
  end
end
