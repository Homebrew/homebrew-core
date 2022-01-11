class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.169.0.tar.gz"
  sha256 "5323c16160285f3c257027178ccd4f4a7bea590eee93a84a0f1b9a75d3636310"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc12b52f41161556ef08c91cac73b4b01d4360e82dcad9794347238fc5b35dfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dee43131977e1679048a1000f1c09e8aba8dc2f387ea7a04cd2e5edf330fa1f"
    sha256 cellar: :any_skip_relocation, monterey:       "08bfc111cee81fe518b2dad484588328a8b2062ca1fe793a321ad3004f20aef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "facba26e73c353977d1bf1fb4c79af6c7c4341d465eea6f93a3a3c89369e719c"
    sha256 cellar: :any_skip_relocation, catalina:       "0209daff11af039b830fdffa153611eb6e29a3d3ab6306db66c2d8348e00495e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c396945873fca13521fa2c1b9004e38a44fcfaf8ef87d51216e343d697308e17"
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
