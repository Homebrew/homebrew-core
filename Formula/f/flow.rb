class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.267.0.tar.gz"
  sha256 "9767067de405a5c853ecb1f3a991fd904c0aa75ec4aee46a396603595c89d45e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c693dfee3193a55808de4be9d5e0151c2c7b994d4b9360525d3ed2ec46baaa8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7df336306c2b5bf51a93bb7c01a1d36386edc292ee80df39af23aee917a126b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b627a81d6f7a56ad6c7af5df9c4dc9c55fa9f48c7199a634a740210ad23e46e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2406cbc61969b05b706c273204f8e3ac8eb81e46a394559fbf9f1445b2e2c85f"
    sha256 cellar: :any_skip_relocation, ventura:       "f28ef333e71240234ec5c65eb93994fd20dc6d108c8d81a6a693567a427a85a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22812dbf705750887fe54f2f37dee24a8bed56274914174f44bb42aa122f1888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725a10ddd90bfb9f228c07cd36075f964a9945a255e45530763ebb66f657da32"
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
