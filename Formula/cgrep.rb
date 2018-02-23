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
    sha256 "cbca15828b0a4b9063da146468d63c3cc157184e031f921abe6f5679ab296e36" => :high_sierra
    sha256 "e32a05aaa5f2faa5a512e545636cd6fce96db0ba1da99869e0392d1e4ae620c1" => :sierra
    sha256 "be9f271ebac608476f316c47a14080cf5b10e026538651b5dbec53af49d60793" => :el_capitan
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
