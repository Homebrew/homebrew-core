require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://hackage.haskell.org/package/cgrep-6.6.15/cgrep-6.6.15.tar.gz"
  sha256 "f58a557fecdc7066ec60653e7c902b8baedcf4f44a81f890265374b6dab9affa"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "9445ad642c67c5ffcbbdee57573c5e7b29e1327cc7933367e02ebc80eaa5b847" => :el_capitan
    sha256 "19b59d7653bbbf270e46d6c6d02a030fce230c3ccd7c6d1a7babc597519efbd3" => :yosemite
    sha256 "efcce83921875a32e7f3a855efbd4fefd17ccbe855e40acbe85aacea1df54002" => :mavericks
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
