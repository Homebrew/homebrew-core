class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.204.0.tar.gz"
  sha256 "69ebbcd54bea66fe7a4a5ddfa7e312b80b19ae2933fd0192081748f10a346f36"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23f012ce4d4fdfb637b6b3381e36a0e58fb002083d3e309bf1e715729dfae7f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dbfab2d14aff6ca2a7aa9137db56bd603ed751726ca96a9d630fad00d52bd3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b79418fb9c483a100a79456a13fe740b125df3a6ff45635bee38cfadbc0f1460"
    sha256 cellar: :any_skip_relocation, ventura:        "19b0989f0d1b2cf6defa51d0f81fe9da8b3aeb4d99c230fcac8ee9c3dcf04923"
    sha256 cellar: :any_skip_relocation, monterey:       "11d22cd752f5a6e34a88b3e80288cf5abc047c9099bcc9ee00bf72fc65fab3a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b5e0a44c7fe15a0ab6f936b9eca31b76994f94cb23e704c4f432c4db328496c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e90ecc590f3c61009cb9bc98b1d8f8c561660329fc8e1ebd2750b1696e04c3"
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
