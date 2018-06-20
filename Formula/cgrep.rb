require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.27.tar.gz"
  sha256 "1c623478e1b93a43eb1f151d20fa1096439a84b6ce7024bb9856f10c6ffeca59"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "d7470f70f2b0a8d9731486bafa8f069e2392cd4b81465603e9df92c367cc0a22" => :high_sierra
    sha256 "7b3bb001c03e52955cb0cf44da16488ad3ce422fc03adcc0a647105a1bc90fd2" => :sierra
    sha256 "27114a40398d711d86d234129babc4b06b9059f479309f28cfa229efae420bc1" => :el_capitan
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
