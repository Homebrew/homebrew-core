class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.177.0.tar.gz"
  sha256 "403b188654e413c8b9f4b292f344118a02b3147e3002637c7a55d38c033634e3"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d60ff59350edabb0bf246f91ed5252f781485972d3c4d94b1ea4810df85241f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ff1e5dacd8b7810c1ed4ad51e42103cc5cd2ea00a2e57866ae5c63273fdd1d1"
    sha256 cellar: :any_skip_relocation, monterey:       "3b58fb2fe5675e42a5d45c4524b1ba17587625cebfe8c99753404161670261b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3224cf648c041ac5e410181df317dce332526aeb8131d8274d587e9e43b2cdb4"
    sha256 cellar: :any_skip_relocation, catalina:       "a3a588f092c02853374883796e4283ea1d53af80f842eb39231a489026806154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb4cb806d3bfd6649a2c6bfaf1b97e98dbd854f69b845786ccdb4338ade366c"
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
