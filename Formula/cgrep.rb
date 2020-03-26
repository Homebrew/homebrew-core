require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.32.tar.gz"
  sha256 "c45d680a2a00ef9524fc921e4c10fc7e68f02e57f4d6f1e640b7638a2f49c198"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "972f5d6688cd84ead3bc27a68a1a80936c0a62327ed6b39e7e7db0c84f88102c" => :catalina
    sha256 "b6a491e69db289915f94813b51f401f672e12d9e075620a51e66c7c8883d5af2" => :mojave
    sha256 "24170492fb0c2955676309ccdedd9c5bbfab037d90215c661ec3cb582a76ce34" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
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
