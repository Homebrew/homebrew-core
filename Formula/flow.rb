class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.73.0.tar.gz"
  sha256 "cfef40febb8db41a8d3c7f8d3da27e5ecbcda59d87a91d76e31d460c064c723c"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "222162737c080f0ed67b758e0f20d98e5769d231ea680b31f0b3e7828ff86949" => :high_sierra
    sha256 "f721370dc877668a1d5a56a7973ba27c25acd12be6691d9b5e547f862ebbc5a6" => :sierra
    sha256 "adaeb69cd32d2fca69d44d97f1f695d90fa39d815d21ef948ef5ab6a594bf7dc" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  # Fix compilation with OCaml 4.06 (again - we did this for 0.68 too)
  # Can delete with v0.74.0 deploy
  # Upstream commit 24 May 2018 "Fix lwt type annotation for OCaml 4.06"
  patch do
    url "https://github.com/facebook/flow/commit/6ad707a.patch?full_index=1"
    sha256 "d21a5325e0b56b884a71178388c08da7712be894090b2a940012cd8a69673ff8"
  end

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
