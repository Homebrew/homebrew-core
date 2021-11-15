class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.164.0.tar.gz"
  sha256 "675f1da86b9c39482cd6d396fc60babebcd9ac80ff3e6ad94f9be2e648b288a8"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4128ebd1ff5549a7581e593c558f6973cd6f6cec75bdc5d963abd04704983b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3405662ea288aeb7d8f042c7a94e74d2dc1659417015a773b3b6390400c67591"
    sha256 cellar: :any_skip_relocation, monterey:       "7838ad4e9c528ab3975a4cb88d645fc7f250d6a21cdd43b97e81127e3af29eaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb3bf9b97ab5ad969cd8368a4dc9ed006c8d57fc7403f180f4acf4903671a37d"
    sha256 cellar: :any_skip_relocation, catalina:       "afb31a464bd55cc9dad4579b93b2db1f2c8eb0e65d2044837955f39b296f28e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "885f86106f7e3ec16ff0c6bc7bb33d88fcc2f4848f1fea5f6500f06055aa7032"
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
