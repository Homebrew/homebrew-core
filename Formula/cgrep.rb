require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.30.tar.gz"
  sha256 "b7aefe2d5b0abc1fb8143fe1e6faed636e2b4eb5198ad1d1f7f6db5121a37da3"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "c48bd1796c39325751ad3b5526c3d0a1c657c1611c7c5178a1571b4d2f2c68a0" => :mojave
    sha256 "b5d1fe2cf3084d6639216f9073b079f415339599d41a8784b8018fb425828033" => :high_sierra
    sha256 "602d854d141b6a449d27afa47b6de20f917d6b361eac9a43c5937c2b5a548d47" => :sierra
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
