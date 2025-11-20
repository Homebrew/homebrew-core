class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  # TODO: Check if `rawfilepath` workaround can be removed
  url "https://github.com/awgn/cgrep/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "6f7be7a24446289421fabe98393d00a46a1751ce1f605d84135e83d0ddf1d49e"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "800117428a6815d9cd0a7c78f6760ea928783c2252aa1debb747d3c05b917d09"
    sha256 cellar: :any,                 arm64_sequoia: "4f8914a4b4537767e2ea7d29e67bf433df1c0afb1d3779c6ad3351e9eba7f614"
    sha256 cellar: :any,                 arm64_sonoma:  "d16db1ff70db55cbf3af82c4c54cda5caa71c44d722d8b6b7d130cec8bdcf2fb"
    sha256 cellar: :any,                 sonoma:        "0bd0c453c86021bc28160966bb6793d99801aa8a7f9362bd6e377378d36fc394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86fae7709704b2f81203afc12ddce5059d4b888a6201f524d91e202815508ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64f7bcace354b59dbe60e17c95a966504fd1b02ca24a8f03576af627cfbc6ee1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "pcre"

  uses_from_macos "libffi"

  conflicts_with "aerleon", because: "both install `cgrep` binaries"

  resource "rawfilepath" do
    on_macos do
      url "https://hackage.haskell.org/package/rawfilepath-1.1.1/rawfilepath-1.1.1.tar.gz"
      sha256 "43f879da83b7b07c30e76a3c31d5362b7b6bb8e235c2698872b92b9fcce3bf69"
    end
  end

  # Fix CPP directives alignment
  # https://github.com/awgn/cgrep/pull/50
  patch do
    url "https://github.com/awgn/cgrep/commit/72748d85dbc2bb8059c4a4782be52347fc071eaa.patch?full_index=1"
    sha256 "04ecc69ec482f0c07edcc07823c284e93e9822128f0398bf00918a81b08227ca"
  end

  def install
    # Work around "error: call to undeclared function 'execvpe'" by imitating part of removed
    # hack in https://github.com/haskell/unix/commit/b8eb2486b15d564e73ef9307e175ac24a186acd2
    # Issue ref: https://github.com/xtendo-org/rawfilepath/issues/13
    if OS.mac?
      (buildpath/"cabal.project.local").write "packages: . rawfilepath/"
      (buildpath/"rawfilepath").install resource("rawfilepath")
      inreplace "rawfilepath/cbits/runProcess.c", " execvpe(", " __hsunix_execvpe("
    end
    # Help resolver pick package versions compatible with newer GHC
    constraints = ["--constraint=async>=2"]

    # `base <4.16.0.0` is not available in the most recent GHC
    inreplace "cgrep.cabal", "base ^>=4.15.0.0", "base >=4.15.0.0"

    system "cabal", "v2-update"
    system "cabal", "v2-install", *constraints, *std_cabal_v2_args
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
