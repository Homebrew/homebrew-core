class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://awgn.github.io/cgrep/"
  url "https://hackage.haskell.org/package/cgrep-9.1.0/cgrep-9.1.0.tar.gz"
  sha256 "0bcdc712fcf21422a51338a7a152e3d3095343f595fd600f0e6e530b6565ecff"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b42f9383d5a41f744a18add208aafc128c66e2c92350b23d09eaab77ea5db7fb"
    sha256 cellar: :any,                 arm64_sequoia: "6fc1f842532ccc160c04bc2eab3b9adad196b4ef96e6eb611b7ab79203dfdda3"
    sha256 cellar: :any,                 arm64_sonoma:  "7d85747ed757e85ab4dae3aa4c75abef1fdebdf4a667c0ee5ac5fd5550b41128"
    sha256 cellar: :any,                 sonoma:        "8753927f7c4b5d1319579cf37128e000e5b126ef2ff37b407f52b59290650b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01e5f966e2a0f4a7bf75801e7de78663703e5b6c816553d6a038ea69f408718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca071d935a0beb72a598f0beef64be30482c475d5d373c025b0ca2bac3ec639"
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
