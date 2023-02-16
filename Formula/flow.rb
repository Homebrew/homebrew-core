class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.200.0.tar.gz"
  sha256 "09013baac11f334bb42624fc861571a65697c25cf0f59f1bedd5615ca8c2e8d9"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68429f60adb557ec390e385046acce612e1f7aaf16b4191f239f22ed1cd309f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f03dc0f8d4733246086b903c6dfeb1678421bbc4e3c5e3bd95aca3e9e6b1def"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b75b0f139e1cc9844f58bae4de6ca255d75bdca68fdacf5a3e2b42e7df0ba475"
    sha256 cellar: :any_skip_relocation, ventura:        "70a04e27cea3040a20475758426638cf57b05e6c126fba33884bbad8d2dccb60"
    sha256 cellar: :any_skip_relocation, monterey:       "fbcab2674eb68ab29e9c35200e46688a3340fcb2dd033e19d86319c3066b063c"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a4959371921e557170a81c5492b4821b3d111c684316f559d3baf71a6a67e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db483edc6ce83e1d059e6dd8ff7a081f65da9210333484e688c38d90a8f542d1"
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
