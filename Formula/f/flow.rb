class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.312.1.tar.gz"
  sha256 "a5e9ada75f319b1044e28009db2226ce35678706448d6add6d8f50de60da6c7f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40ac2ac977d19ab6b317c37f70fd264fc16642d37cb29f308b84a5173d32fff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a0830d3a2449726f2ad51f1f14ebc2f107cbf93b7efc9d6f419fc033cd33cf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "366e1d01ca9c312166ce1b16f6ccf4f67396d5ab7bcb9a7aaccb5015c487d1c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "301f0aa73ff513d2639a8b9972b1d8123bad4283a6ec08fcaa3f07cdcd79fafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24b2e2d17fd72e8b712421523b74c7f81769fdbc25f6e6e5e91c4e2ec1a58fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5e0c4a5a1c3b8b48e196a4dd809ef18a0ee85344e754e841dac7ad301397381"
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
