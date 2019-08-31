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
    sha256 "014a53fae554cce2187c4ba1ed579dd8cec03d65158e9150bd7d02b36501707c" => :mojave
    sha256 "4e2e5c6fdc026151899b1055300e7b7a09f016a41f8a9a1baebcbff4e0728565" => :high_sierra
    sha256 "8800dd76abc3faf39de9920a73e4f779a7624676b303d13bc6ed84188b0567f2" => :sierra
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
