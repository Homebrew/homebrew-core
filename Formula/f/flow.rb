class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.259.1.tar.gz"
  sha256 "4135cb04985ab738d6fe7eda85901ac3b6e2b050ca72a70ed02f3db68b1ac1ec"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bd4aa9ec2c0fad1138d1b1728bd71028c0051793d586c269f5853560114e0fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa2500b99985c884b360f9e781e13fe37e7e7804f14909c893a2aa7e037903da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fd8706e3a0722b21449e489e9a16b9702ed2b285cd5c589655e7687af056959"
    sha256 cellar: :any_skip_relocation, sonoma:        "9392a847355f360fdb5b853afcfc497e6b45296a18d4414920f84376221d57e1"
    sha256 cellar: :any_skip_relocation, ventura:       "bcba56c338970adde9d546cf867df9e545664961e4eb524c813829a3e148f1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33662d4445065a3769f63de735caa62aad81dc9ea9d826c79a18a7834ec29acd"
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
