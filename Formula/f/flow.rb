class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.231.0.tar.gz"
  sha256 "4ff76c1f68e326a99eb33054ad7681b3f974163dae4387d16526a8eaeabcd237"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c7f9b0a93fcecdd12ec22d888738b65a8f583affe17840433d5b286569ca816"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72b87fd13f70f094c66bc61e315190ddebbd4efcf402566c098495d64d5322f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a6d56bdceb46d85d91bb7022f2d4a41be51b4c7b9071d3170b19bf2071edd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5785285824fd2c43147113aa8513341605dfc56dd522d64e6071e5efb8b472ab"
    sha256 cellar: :any_skip_relocation, ventura:        "5c6f965921904c015475c3b4a1059adccccb15ca546363eed4ee2c9b3d9c63cc"
    sha256 cellar: :any_skip_relocation, monterey:       "931869f5228212a23f251b8e4b986034aad1164311b87242fd78418f40430519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "853663899b097b93be25d170f0f530ecbd76dcf2b4a2ac880b7a3cf730cf074b"
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
