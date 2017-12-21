require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.19.tar.gz"
  sha256 "932237b12f1802c884d3eb11044e0f38f09e21f7bcebe56e05e7902b40e4ec55"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "e248f71da6dfcdfc226e540cf9ed472f0f311f5d266f8c114a1a16b80727fba6" => :high_sierra
    sha256 "b15a8e309b89b16f8728cd000b3849f558dc2b6164861f9157a0b720a7f5b578" => :sierra
    sha256 "8583bba93e113aaa90f0ad04c1933bf1758abc10c6ef8a14abdea9e030dc5a23" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    path = testpath/"test.rb"
    path.write <<~EOS
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
