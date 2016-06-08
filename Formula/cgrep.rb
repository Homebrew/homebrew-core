require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://hackage.haskell.org/package/cgrep-6.6.14/cgrep-6.6.14.tar.gz"
  sha256 "9e46ab2f0014e585f3bd8fd85a86926acec04b338bdfe2d6af82ca35cab130cd"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "829332aa6bde15863c51de6f44c4466c7d789871ed5c98901820c5ef453e2c36" => :el_capitan
    sha256 "b0f75aec38e853fe99ce8ac058cfa2501a9b5581d4e241065ec58627687d5c6e" => :yosemite
    sha256 "bbf36b6488a106bd40efba61796d82c83b3b8d8ed930ad091f22ce32dab57c43" => :mavericks
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
