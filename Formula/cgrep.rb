require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://hackage.haskell.org/package/cgrep-6.6.4/cgrep-6.6.4.tar.gz"
  sha256 "c192928788b336d23b549f4a9bacfae7f4698f3e76a148f2d9fa557465b7a54d"
  revision 1
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "355d20dd4a4f015584a193d89b62847cf87d5bf181ec361c9b24808b5b3c8e5b" => :el_capitan
    sha256 "e06487ad35ff7e9661d7167fcffca0da9833ae054b31018b0cd4cfc363367bb1" => :yosemite
    sha256 "d3e37cdde6c295d20ae53379c410ef2e4f54f1e504aac56c13fc6fdf8bbfa6c3" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    path = testpath/"test.rb"
    path.write <<-EOS.undent
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --comment test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --literal test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --code puts #{path}")
  end
end
