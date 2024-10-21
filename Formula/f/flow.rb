class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.250.0.tar.gz"
  sha256 "1b8e9ea2ffaa2658f41f4fb207c737472eb81e35ec5baa5a0eca93c0f2b204e6"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0457b3a002e3d09f08f1960c42c3fef265a19d1c0d2119443f25cd3dafd6a5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9913a93258cf69da48c149762607665fc2dd3244b05d02d8e8582957b19f72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3df44231b011f8446acd64f75fe9faac2f15b6b548d6e5572ec36c510fb83806"
    sha256 cellar: :any_skip_relocation, sonoma:        "2983bfddb2f2046c5a555ae6d3d609791e07e3fbc58f09c7f4753e020c6ac49c"
    sha256 cellar: :any_skip_relocation, ventura:       "403a1fb6fc8a2a814401595973dc6e2e068aa08a5660561fca5ed00802fa82e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e409dee6e44b855117ae1fd0ba63aef9b9837cb8c2cfb73ef30efa7539c2d2d"
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
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
