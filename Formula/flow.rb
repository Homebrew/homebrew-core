class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.166.0.tar.gz"
  sha256 "c98fd1093c211b10b9e9c258ee8ad0f15fc51accb975ee59022ee70e3891e585"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5d396c4694642fa520e5032bee729c1793db141f60fc945f94f5ce079e2dbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31b43a9e8b6c7ceb6cdec0b079e7b96d2a9dfc560338f55ed85a5823b5b7b9c9"
    sha256 cellar: :any_skip_relocation, monterey:       "945401fb24b130b96c0be37947dffe38c39529a1b64f755a5ed377588974056b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd7e639c4392bf88361a0bb6b624bdf0b4699ec20f9314a08c1517847024c4b4"
    sha256 cellar: :any_skip_relocation, catalina:       "c383654ef072ae080682ee9701fde88dcd6a1bf55568c9c35817d63ac3c924f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50685b8811f23fcf9ff0590a65267b25487abda08d469bad5bfd9ec69c13f8c4"
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
