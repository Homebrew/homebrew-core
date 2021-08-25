class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.158.0.tar.gz"
  sha256 "e180224cb6daaf565ce04e63c7301e3f65b7a29e616de770fbe823ba0836f805"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee5137e0822b41779b6652b5518575ef42688967b65a55531f10201e94316cc8"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5781f9c70f72644754ce3a05d9dd67a8a9881f57ccf30cdfd4c65967af430ba"
    sha256 cellar: :any_skip_relocation, catalina:      "6575ec830b93973af7674d72b895b28bd84e62b7e653638d69df27708558a2a1"
    sha256 cellar: :any_skip_relocation, mojave:        "361b4822ad404563e5c05a3d3ce7cd07c053834326c9bf86eafa65780cfcfb67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9692a4165bc891c2d516bdc894a040f081ba8cf9b07a4c860d6f4709d47bd1"
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
