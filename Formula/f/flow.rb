class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.329.0.tar.gz"
  sha256 "74a5a84bbf03cb9c0c6666ed033b3b0ea2b06115e40aa1df012ca3fffa96c640"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33907c7318f5ac07d757a67f5d487f721c3be19ed71c7937c87708c922ce25a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7431b094578b068b768bcdfdf7b95472f6c4d9eeb0cbf4c975cf53ea3643895b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51889feab4215b9e370eddcdc4ceec90eebb9f4c67cd4514410b10921f1b73f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be6bb56803efbc84188dd2d79773cfafa2217119e84adcbe9ea3ae2339dc006"
    sha256 cellar: :any,                 arm64_linux:   "d0dbe2179e2cc1f30e87c1f7ee24e917db768a0b70de231195414a3996218517"
    sha256 cellar: :any,                 x86_64_linux:  "bd1ecb4803ae719f0318c1b519bed1c18829dcfeb8bff46f96404ed80ca99540"
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
