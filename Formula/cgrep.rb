class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.32.tar.gz"
  sha256 "c45d680a2a00ef9524fc921e4c10fc7e68f02e57f4d6f1e640b7638a2f49c198"
  license "GPL-2.0"
  revision 1
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha256 "cee7f82d8e3e6b46e2afae649e13cf55202771da2473fbbebc6a712aa2f46496" => :catalina
    sha256 "0ac8d5bcfc0ce6d295aa617cf0e5c624c61df4fc28a2ddb8c7b21bf753c7e369" => :mojave
    sha256 "55118e5aa9a1999081105f7b2aa3e00793de45623fa61c0e69c6830e598d045a" => :high_sierra
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
