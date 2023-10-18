class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.218.1.tar.gz"
  sha256 "891940cc12834e2fcd7730905737bdf6494bdb728ec8ba6911e1d05b003351c5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09c0ef1d8d015f89449df64c491030e1d3970030ac2a2e320eb842adac148bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a37721c9c9e488bf9f4c51d2f61ba1a5c56e0adf200202be7d8d418bb7a574d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6e53ce6ae8f7f741baabbc37addd01857b8162a23b0eb7253902330cc2e11b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e655c02a4f532da7fbea9712fcd5982af4b9cccfc103d21095b8a72446bdfd6"
    sha256 cellar: :any_skip_relocation, ventura:        "5da4823fe6eb126c9ca48dc6240af475bebdb7301365be8f40c73b37b3daa9de"
    sha256 cellar: :any_skip_relocation, monterey:       "a165e496594f26e14725e3c7c81b6998faf6bf242af2dbf5b1b32052767e1100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd901394b29a82a45e0e5da1dcd574cb91c93e5870cb04e0572a6a9562e92d3b"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

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
