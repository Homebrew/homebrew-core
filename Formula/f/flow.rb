class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.284.0.tar.gz"
  sha256 "f91c9d8fcd1f1403dd883e7be170af41c6b416a0188af2d03cfa3fb1e6809e54"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "130f2972a7166071d2385459c8a729521ab853fc7ebcbc0241ed6ad2693ec6e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d9ffcc5e75635611ae46ada03fec06897d0d1b0f0fd5d08f03e295307f7e271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b594fdc31d17a76dbca7b3df8bf0801275c367aebb1d1790944cbb9f8abe52f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae7236d0bb299f789ce14adb8b2e14b225b70a2b75db92856c5f1c7405852fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd74c9ad127f0f676ac51d8e36f18826464cabd4bd92642f0a77db67be59685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa2941090c4c6615352facb0018ba2135b7e980b9a5d0cecd0acdfa81b2e942"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
