class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://awgn.github.io/cgrep/"
  url "https://hackage.haskell.org/package/cgrep-9.2.3/cgrep-9.2.3.tar.gz"
  sha256 "80119410ad24c668e4668773e21ac50439051bdf12d61668995a7cf652304691"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "01fdd42f0f899829a1d424775f007c97038081b10d8c415b57060e9899fd5c4d"
    sha256 cellar: :any, arm64_sequoia: "f942a582bb2c973b99a9c72c4884d4976d9256d7a1b2382167e37f868dceb1a2"
    sha256 cellar: :any, arm64_sonoma:  "9ba33d511c7e54ab3214f6b214b5a4ac2cce87b484624b8217de9882b293f0b5"
    sha256 cellar: :any, sonoma:        "99684e8c50a0abc2423afbfa7cc48c320b8bc76f6aff279784a364166d1cf544"
    sha256 cellar: :any, arm64_linux:   "19bf36369385f53e73b8e9c5f17d0c00ac11cf18e520066bf112f9f579a1a5cf"
    sha256 cellar: :any, x86_64_linux:  "2301142f2d5801d53ab94ecb5a32fe18a6e4d302fd17a0f65f655fb2dbca5e71"
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
