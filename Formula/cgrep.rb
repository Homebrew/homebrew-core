require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.22.tar.gz"
  sha256 "aa5e016653eabee0fc47bf6a1cd46ec961b7c305a4f49b0feec66881cc8f2183"
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
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
