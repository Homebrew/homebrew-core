class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.196.3.tar.gz"
  sha256 "ad6ae3fa9299eed6e5e3348911fe38857dbab1b233a3cc38662ca9723f801593"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a33e3af56166f5d7fbcfa7d761d9621e20b90b9b5ae6c2a12dbc3621c256ebc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ab3d7b97505ba669c8a2864bc048bba67549d918ace9a0498b0244e03fd8c1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d236ad13564a753b416c0747830c05afe20ee6f3feb7532b07f7c78be3628f0a"
    sha256 cellar: :any_skip_relocation, ventura:        "09f434024ab59d522c905a37e980a4bdd36c71273513f6d62acde7ef37b35547"
    sha256 cellar: :any_skip_relocation, monterey:       "c78b5a1b5067d37c28e3eb7f659dc1b4a4ad09a0ceed99ab650ce48e3f33ba35"
    sha256 cellar: :any_skip_relocation, big_sur:        "45193d54ff2dd94bc57485643b17547d319dd506090a05f72d5dea33d01dad79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4baddba63abdb7c2118f3bfbd821c381c5e57d9d14b2caf180708d24eb7962"
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
