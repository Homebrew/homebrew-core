class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://awgn.github.io/cgrep/"
  url "https://hackage.haskell.org/package/cgrep-9.2.1/cgrep-9.2.1.tar.gz"
  sha256 "066379b1d742595aad680e32acf1b950443c1891a05e0e64336f448044eefa57"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc287175e8bc20a925028e3b4d0939feb5e693116a0a0514f4bf3a6e2ff2d45a"
    sha256 cellar: :any,                 arm64_sequoia: "0f9922f03e5efb62189cc6b64320f52bb244fc7c593f48190c4246d78192e243"
    sha256 cellar: :any,                 arm64_sonoma:  "e131a6adb643d51cdefe5d20f2253e73eba15818d23f07a384ff85f50760aac9"
    sha256 cellar: :any,                 sonoma:        "9d22c8855ab9676864f30fc331a8e2ab1ce2b6e848338a400d31937761722778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a642dfd4b6e712012bb882ed1db8c3122ec3d886f496949bf7ae01d2a5501b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4303cda845989c5979466ad0a79666b2cbcdda682927f697e8deaa1b8a8379a6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  conflicts_with "aerleon", because: "both install `cgrep` binaries"

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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
