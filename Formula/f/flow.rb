class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.252.0.tar.gz"
  sha256 "4fd818eefb77e00386f66404ead4b580de87285199865d2cdc6fe92768c30a97"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54045a849c80f349ba66599eaa646f6d1f7ac7d1e49d294a90dfc0f6782301bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3101304b30caad783479aa215f231273d8efd90e98174e651f0d33b9d5225671"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40d5ba0730f21db885aa01aa0b08d17bb305ab811c72e8add4c1e3cf2a52ccd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fcf9780484136ace89650ccf745a57a913ffa69d887740a4f7e6393ad31675e"
    sha256 cellar: :any_skip_relocation, ventura:       "c32acfb2aa09170db356f69c5cf198db398a13b57aa2dea7ca92a575d149e6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1b0f840e81146a94aa7ef68e74f391689db663d7aa5856f7e7c1ca40c7c91d"
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
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
