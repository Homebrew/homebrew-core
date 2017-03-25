class Fzy < Formula
  desc "Fast, simple fuzzy text selector with an advanced scoring algorithm."
  homepage "https://github.com/jhawthorn/fzy"
  url "https://github.com/jhawthorn/fzy/archive/0.8.tar.gz"
  sha256 "44293ef6a33ef5c9400b9546c580170a2df0ac4342b8fe447cee2af35e241b89"
  head "https://github.com/jhawthorn/fzy.git"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fzy -e foo", "bar\nfoo\nqux").chomp
  end
end
