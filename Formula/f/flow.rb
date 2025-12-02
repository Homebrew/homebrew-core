class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.291.0.tar.gz"
  sha256 "e0e4248436a8e69853682886543dc6c8f8e4ed32e522fc4c8f9108e157f522e7"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53daa9e3a298a097bb39cf66b7adea40823c1f6518440d2d4aa0242e78523ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd63b7f07680d921e66f77ff7fac779563c30080348cca98ad83fd68ea475be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3d067df1b1ba853f358c16fd6007e2b15e7c54d079c8c805e3cc454dfc5c6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1781e01b9589645d33302fc7655b8d2f337151d5ed8ad65bbc242fc7237a2832"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d6f6edc5e7d8315c8b4c686faf225b33c81e36e4b0635c96a6d9dca400b102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c0b710c9ccb6f944b67f285278324ac6af27dfefa2a7c0fe82293d6fdca1909"
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
