class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.308.0.tar.gz"
  sha256 "141dc2a133de6974a1886b537f76a397df3303af6abdeb0818896658f995b1dd"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbe92230376ee258fc148b7bf02e5bbbfe1d365e183426250c5017ecf4311f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "897eb769cbcc6f9d944e042adb41be002466fdff8cca4bff4afa00b6eff3439a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7909417772ec2fb57489168f1fa6bddebc1bdc56e30dbaa79065698a9ae6d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f659db0b1279809c114086d8875be3ceca3edc9b594e475f23553be78fb0ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1af55d439c5e342cd48dbc82a621959277f0f4e6e2cd1c9443e2f5513a1883fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e312b6d0efb0bdde256c30cb2f6227a4c1de94e877157ec46ed062aaed2c35c3"
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
