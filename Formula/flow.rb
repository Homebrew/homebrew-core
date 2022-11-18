class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.193.0.tar.gz"
  sha256 "da96e3bfc1065faa27fb5b5d6538f5888ac8b69b2d4b1757bac2b278e62ad363"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f070445600dc77fe45bcd9cd96d00e27cdd164de145434b92135ab8f591aa14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a19fd3b4f5a5df661b896c58586185b40b7ee92a59bbf2ad12985dbd9c68cf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd220f055925b5d8fcae387df9ecf6e4c1daf31fac4a8dc4ae9bce1143158296"
    sha256 cellar: :any_skip_relocation, ventura:        "a6a590552cdb405cc292ea625c5c71abfa90414f45095a0a95f814b43b49c790"
    sha256 cellar: :any_skip_relocation, monterey:       "a94b316feb8cde0fb27f6d73dc88728c487b687f698de3036fcfb5454b1356db"
    sha256 cellar: :any_skip_relocation, big_sur:        "2566b21828be3258a0bdb00bf0f28301d583e391d5e52b3cb4002c71c7c005d6"
    sha256 cellar: :any_skip_relocation, catalina:       "2dc47b9a9599c6d774d63776db6e47e6301cdcac99af15399b792fbbcbb78d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f598e1512e02a1298cced27c21ea5359b2b356bbd8b0e0425041e4d8b841c6"
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
