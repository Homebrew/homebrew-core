class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.317.0.tar.gz"
  sha256 "c83e5d6d4f02eb06ec5a2a0e9d3abdce347fda2cd9562041c53d5466e40089ba"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35537acaff9c4b75accd3238ed70e86c4efcafee23e5a3e226e61cc1d9ec52d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b58bb5a171598e231f473f9da50925a33df3aa64a1e208f886f02150edd4c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa78254525f0da636e50d04e5f53ab90ce0f69639847fe5d54a26c57b9b4cfbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6bc01c4dce8876c6675d2301d2902ef493938b49047992e79d06d928d6029c6"
    sha256 cellar: :any,                 arm64_linux:   "638e36521ced82ccf775dc653fb147c51646d58630a75c11cc1ae1e844047a9f"
    sha256 cellar: :any,                 x86_64_linux:  "f367fcacbe40a3154a714d32615d3291e384edef83dd35617077714761ab3dbb"
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
