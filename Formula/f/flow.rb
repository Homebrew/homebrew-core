class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.306.0.tar.gz"
  sha256 "1479c8f0723bbd555068067d19aa053c749bbb8e688a5bb3f10dacb5e4dbd67b"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4e802eb16fd4499a16d0163d4071407f4783e0c42d437b4ccf6c6b49c4a034d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7816f7ff0bbb2bdd5e6e3359d99c2b8fb2bd7c3099440d83cf90221535aba856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9f09d77ba908e6342931855dbe050d360ad8afcfe406c24b9df556ec9dbab32"
    sha256 cellar: :any_skip_relocation, sonoma:        "35536b9f6db5044d3f8a2ea216ae350602eae31883819400593d7b39d0bdd98b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cabac61e0c4713fc27b681b4fd46e35262a7264c633c1d3d5e497f84bbabc6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49241db5783048c9012709b5f76c3d09c802ae491fda096697082693b416906"
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
