class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.178.0.tar.gz"
  sha256 "29da6776bd30181356ee6cb56e2ed166e020251933f532822c0bb3016b9375f0"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33bb7769bf397ea00c7058fc15a4ffbe14010d0c93a1051830ba58d5e7abaab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf6f2057f6f639e259b242e6e85b139f7eee103a92d040c7dd583b8b24b3302c"
    sha256 cellar: :any_skip_relocation, monterey:       "af0210529c1dd2d3046c8fa520d1bc5a1dd59bb413ec854577efe66dc9f71dec"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ed724bb3cd38fb3cc0a9a5d235a87a972efba0f133781a08e7a6536147c5c1e"
    sha256 cellar: :any_skip_relocation, catalina:       "c07e82347c98414c918f5b21de1d4eb8dfc673f8624d5e959e437a8536adecad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "025b69ee096b06015659d928f2d457dcd63fdef6e2f12abfac485526776f6fef"
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
