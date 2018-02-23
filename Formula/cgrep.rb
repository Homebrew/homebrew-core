require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.23.tar.gz"
  sha256 "d4acafd056c4acb46f74880277e1a65e1d27ace98f418914d09a88a1744e049f"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "079e627cdc63604a51f0fbd6c1bd7b2b8c270279b950953ce6ee9734965182ac" => :high_sierra
    sha256 "8f46a454c1672923329028e36d1fab404325d70ad01eb4505b7506083c5c88d1" => :sierra
    sha256 "7d7731bddd392feb5b1c22289e0581daf9536cca79833c0c6a2a92d0633c5bcb" => :el_capitan
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
