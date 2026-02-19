class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "6f7be7a24446289421fabe98393d00a46a1751ce1f605d84135e83d0ddf1d49e"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "37bd0ff627442bba40b99ec4ece6957d02008f611dfc534a76100b7f9a8caf3e"
    sha256 cellar: :any,                 arm64_sequoia: "ae4697fe71f6e15c595da258cea8289c32ef234d99b91580090d9edd48a738e8"
    sha256 cellar: :any,                 arm64_sonoma:  "caddb9e8b415c6ea98cb60a47c6b5037507186833e8db354bbb8913fe50bd1f5"
    sha256 cellar: :any,                 sonoma:        "43a71f50530e480907517a299f1001c590049529f4b89ea198551c5cb6f20cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44050fc6cbd4cedae9941e3182684c12acfef6ecd08ce71e80fe6c0d1a80756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d9852362ac5b03d08e1c3fcb6679e02962f1f8e8874c5ae6f3644b3fd38304"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  conflicts_with "aerleon", because: "both install `cgrep` binaries"

  # Fix CPP directives alignment
  # https://github.com/awgn/cgrep/pull/50
  patch do
    url "https://github.com/awgn/cgrep/commit/72748d85dbc2bb8059c4a4782be52347fc071eaa.patch?full_index=1"
    sha256 "04ecc69ec482f0c07edcc07823c284e93e9822128f0398bf00918a81b08227ca"
  end

  def install
    # `base <4.16.0.0` is not available in the most recent GHC
    inreplace "cgrep.cabal", "base ^>=4.15.0.0", "base >=4.15.0.0"

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
