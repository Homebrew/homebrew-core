class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.235.1.tar.gz"
  sha256 "cae73fed129c00c65797c746ba52831ea42dd6101ee5fc40ed79e2e16b409321"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a2d8ce67ee8a511ba995076e9c71579cd2bd5c5c7a6435e955a592c19cde330"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be64f0684c63ef8a6c0f59e8aced064915ebde3f8d20497465d0609e9711fa40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26b5ae23d932ce40152e16ace675cabcf4e251046b0cd88c307706a3453374bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff97fd456d64104239aae56d501924e4a38bedd6ccd8aa614dde9b0713e2c0eb"
    sha256 cellar: :any_skip_relocation, ventura:        "97ff75623541ab8149f6d32405636b7b2e05088371fc7ca8a5a1a30b3c778607"
    sha256 cellar: :any_skip_relocation, monterey:       "9411c698aa8f57a80dbd9332faceed5711d99f42d41f4068b966e44752962209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e18ed981af515aea33fe444ea7fdeb968076973279fb8546323557cf1a510299"
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
