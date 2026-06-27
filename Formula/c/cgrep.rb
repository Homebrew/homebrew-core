class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://awgn.github.io/cgrep/"
  url "https://hackage.haskell.org/package/cgrep-9.2.3/cgrep-9.2.3.tar.gz"
  sha256 "80119410ad24c668e4668773e21ac50439051bdf12d61668995a7cf652304691"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2121aff4aa6b64a0d2572441c258f462adbd5bbe950af077038397d4585ea71d"
    sha256 cellar: :any,                 arm64_sequoia: "74fc6cbccf7d7537d1d2c263d451e90a701902940cddac7144cc9179a6df4d54"
    sha256 cellar: :any,                 arm64_sonoma:  "454f895083187092030e61d915bdc956259438f81f2acddbdf9ebeef15c3b8c3"
    sha256 cellar: :any,                 sonoma:        "aec1d36a206a6467cbae25f5270aee6c4465c7ed7a58d7b1905ab5f1cfbbc46e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f91c22162403e2f54a8db84af60afd62d9603cdaef6935241fb47659db2615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6850439dc85753748788cbfb76565b78266222b4063b93d50c2b300104ae72e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  conflicts_with "aerleon", because: "both install `cgrep` binaries"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~RUBY
      # puts test comment.
      puts "test literal."
    RUBY

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
