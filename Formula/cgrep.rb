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
    sha256 "ad692cea91721d3a6790393d4abf7d5b1baf7d5836619df9ad306a9aaa95ca82" => :high_sierra
    sha256 "ba15c5f7e86bbb71aac18461e2865413cfd90d3794f7f3e53ab241eacb2ddcbb" => :sierra
    sha256 "3427acebbfe2e88072d227cc565b4d577c6900b2694bf39b01a985dbd15f41db" => :el_capitan
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
