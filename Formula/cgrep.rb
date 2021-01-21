class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.33.tar.gz"
  sha256 "f0d7114e9c26dc3ff3515711cce63864f3995ac06ed3743acf2560fc5a1eb78e"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "4047191dea7a4ed298ec2b30bd9cd1a50b4a06f6cc6ab8c595a02df722c4cfa5" => :big_sur
    sha256 "917b7ccec03d60ae5fcd80da9544cd294db6d188ae7b14a894a39a51dd5459e1" => :catalina
    sha256 "0a3945e411e44e59e77e423caf8e445a6dbe06fef7724abb12612ae888707280" => :mojave
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
