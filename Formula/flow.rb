class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.168.0.tar.gz"
  sha256 "c21a013864c4c91f129d306e7d2dde946b0cbdbaa77f82b502b3d5f42122434f"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd93230a6b58206d284e45fdffe44818accd150b633682ff7710e2df612d1d8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fae6917b1547ef6afb8835c168331a125629c9664044f72f4209a93a2b3cea6d"
    sha256 cellar: :any_skip_relocation, monterey:       "89bda5a20a528d7c0b18b08d5affa513bc64b0c227b0af4e51fcb69824a6bfba"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5e611879d57c183d994fb0892d590db011da861b30853883640c6605d42e094"
    sha256 cellar: :any_skip_relocation, catalina:       "cc844494400b2820dae6e97bfd265a590b2dc1058725cf579c799e30e3c9aaf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea4db1d8721254737ca3b9a4a411be3d90525d44677e48281604d5c67d29de0"
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
