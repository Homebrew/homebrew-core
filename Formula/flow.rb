class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.198.2.tar.gz"
  sha256 "59cda5d6cb3678dd1b7d7b6457dfeab46bc729e178ef1aaeed408fd049c84b12"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b432824ab33b17e11b2cb78b20a9a6232396dc312eed9f80e442be0a7671811"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9c6a56269833922465097bbc18fbbb065c7b324aa5c7e7de9a6cdd515bc2f12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8121ad24ad4db755bf7198cbdfc16c4a5a9ee0c6ad507a76b1ebb40efc2a0655"
    sha256 cellar: :any_skip_relocation, ventura:        "f98f8f743b092ff66e8f4defbf0b7e38228559a31e98ba4a17446596c81fb151"
    sha256 cellar: :any_skip_relocation, monterey:       "480d75fa282f8632eab594213a7d1f9bc8e3ab88e4e575334968beabe1c74964"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f6606ea298ef0906f76e148844cc28cbff2d2e9d734ead73bc166686ee6263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17a032536ca74394abad08ab106e911b20eb366a9033bbb88e0c79aba11e3eb"
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
