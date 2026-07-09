class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.322.0.tar.gz"
  sha256 "798b5cf6d87f3775395d23daf6de58f9956a6ac48922ee41e79039e492186215"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d52f64888c13658ac63ce88f763f9f9e45fc41aa81558ad74ac461c07d9f2088"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2217712b6cdc1a6d1f1ea07bd0244864fc10dd02caba95043cb21f4cc8bc99e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e64c1af5428a6fc3ecdb78e985ef36eedd4ac6f83f69a33641555f11ff5eef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9355bd1322a86a01d44f1568d3030ef46c4c946f2e39053fa9de1ccc647ff2cc"
    sha256 cellar: :any,                 arm64_linux:   "d33d01ba724486a8ec57d263cfda611fab6ad3fdc81256487aa4e7f2f19e895a"
    sha256 cellar: :any,                 x86_64_linux:  "56e3320049ca590a38d684c4e477af562ba70db1564898fa2beefb9eae2cb1c3"
  end

  depends_on "rust" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args(path: "rust_port/crates/flow_cli")

    # Resulting binary name is `flow_cli` but in the release artifacts it is renamed to `flow`
    # https://github.com/facebook/flow/blob/main/.github/workflows/build_and_test.yml
    mv bin/"flow_cli", bin/"flow"

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
