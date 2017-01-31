require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.17.tar.gz"
  sha256 "2508563701365d9b49c9a5610a4ff7ea3905b2d9cd77ac332f485322d93bcd07"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "8f3fcc507950c77381ec98e28806cc23851559975de8d71404697685a9e93fb6" => :sierra
    sha256 "3576ca83c22cb12ad59b3c4821e7b474675a0167c711859ad4cf5c8774456d0f" => :el_capitan
    sha256 "015553f35840cd8e3f88b231a90cee8ad96b90772356f411d87f40b50fc36863" => :yosemite
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
