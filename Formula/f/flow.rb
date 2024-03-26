class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.232.0.tar.gz"
  sha256 "905a2a21d0056ba809d6dfd280068fe132dd25c522cd4b1edc2658da88500b0d"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08a3f58d3386582b38c2380572c30db9c81771970df16dcb0da0f789fdb19834"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59feb5cc45c62ad7e23f14fef84011edc6470dbed73da23bb2f2f0fcc05716b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9de4179c2e6a697b83fd2fadefc7c56e08a35a7cd1c41dfc3ea6b93ca09ce33"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bb38fc54b574cea0fdec4b9b4ae321725df386db289c59fc3ab0e2c55c98118"
    sha256 cellar: :any_skip_relocation, ventura:        "dc1cfd7e15298d2848a3ab2996707323e5d381004b484bec9e4d5d13051aa4bb"
    sha256 cellar: :any_skip_relocation, monterey:       "dcaaba266e794e092e18b06148e5f016f3f58d74aae9af6f9741264e2161fce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c00364242bbab14aa017099459e4d867f68f9e3c5176fe7ccd6ae13b1368ba"
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
