class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.76.0.tar.gz"
  sha256 "a73d15df7ccce8d993288e88b7205954a55bf40773b69a23af9cf8bc8d0d6832"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d633b9720622df1261b507a16329d42c8473ef8c79db6e3aa60f731ec96ae5cb" => :high_sierra
    sha256 "82540f803b72bf4b4b02952fa121adfd2c78f7a39ff229a6dd4f476072dabc39" => :sierra
    sha256 "6f000b5c1b239e6e23b6072da9f65ac336f39f029dc001eb052c4132859bfa8b" => :el_capitan
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

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
