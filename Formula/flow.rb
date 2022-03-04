class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.173.0.tar.gz"
  sha256 "e7536be16211e338a792a8818c377f06780cb0524f9208b666b3272ca0044f77"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45f681469eb629b1b0224b183f19fc570ec3e7c20de156803556840a7fa15274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee0aef0487a5752143e82946e076210c4f06d0c38390527d5f9bced152643f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "422f07e09127e910b6f46a3e0c02c7cbb55c38ec34409c9b1d1190b1f3114363"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d49b4accdd836dfadf667285fac5d26dbec5c929aa553dbc57a19b18c5422cf"
    sha256 cellar: :any_skip_relocation, catalina:       "2e981a10a2e7f06db5755cff0ea9cb02f3db410a1cf7f38123c11de006280fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2246b1d5f0296bec8e6890b76501e624be594b33b6d5cd73b6c1a366f6a64c0"
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
