class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.130.0.tar.gz"
  sha256 "db3e0fdc2d9b2f7ee27b7e5d8bb8d18800f08c97c763637cf1d117ca56e5f43c"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef7d4d555a0951c9a46da0658f663fea486ecbd80130bfecd5943a60709545db" => :catalina
    sha256 "d48e7cd5f39ee1a9800ffc77acf119004140a9bb7d6e4c0694a7efe123e3d263" => :mojave
    sha256 "0eead519806a2686d4a190b486d944d28ad97c9780537ef472f994ca45f4d4a8" => :high_sierra
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
