class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.232.0.tar.gz"
  sha256 "905a2a21d0056ba809d6dfd280068fe132dd25c522cd4b1edc2658da88500b0d"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8df69523a128e518ffbe9486e7fb5ee64a6d4c78997ce37de4e54c92953951fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cef89fc145e0453f8b3cec1d8073250f9116357110da95452a215082a71f7b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a83a56e547539374652b8148401b9d514fb934095977fce11774324ed90f307"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9623e2c836ef464648118f9955f0f032fef5af2442c0cc445d264744ba8145c"
    sha256 cellar: :any_skip_relocation, ventura:        "a8fc2202a359fcbbc9d9729e44f584adbb8010e5e258e3d94d86d6e2efc345c9"
    sha256 cellar: :any_skip_relocation, monterey:       "f503a938572054233c4f8ae928c9437d787e5427c9fac439efa73e04c870bc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6bf756420ca89def0a195637aca019ad304f63d049abd19458be6b6aa67bf26"
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
