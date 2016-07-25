require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://hackage.haskell.org/package/cgrep-6.6.15/cgrep-6.6.15.tar.gz"
  sha256 "f58a557fecdc7066ec60653e7c902b8baedcf4f44a81f890265374b6dab9affa"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "1317722acff1a6cd85f28e6fd053ae970a737aa83adcbf1385a4cd02a03629ee" => :el_capitan
    sha256 "c77f375e2aa5672a3c2d1a09fbced92ec61030010bbe7a0a92ddbebaec69c122" => :yosemite
    sha256 "5b6562ffc2f147e4e5ce913a78cc94378119e01b2f4bd9f9ef295caaf0859b18" => :mavericks
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
