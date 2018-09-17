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
    sha256 "a5a9e0f032374564c3c4636c2aef31dc41c5a0b441a69356bfdc4db27d30e934" => :mojave
    sha256 "d5c98ba9f21a7946ca53394fc66f7145593a8d33427e4d0867b73f2342dbe5af" => :high_sierra
    sha256 "8fc2929f882103c18dae410dcf66f667d4c32dae6dd13a9c7b0ae0c87c980ef9" => :sierra
    sha256 "a3570fdcf951b804efe6994162af327c2984650e3d1fe4a1a54e3a473af8630a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
