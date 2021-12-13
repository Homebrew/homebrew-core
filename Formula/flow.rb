class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.167.1.tar.gz"
  sha256 "04394c7171d8a9ca8221e53a3a9cd11a75b08d9cd88efccf722d2c08d310a71b"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836ae53a486c7dbba774f9e676612c83383ab93a402c01e0d8db21be441cd641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e2d5fd677986900b67b5f3fa7d5442c4733b9415bf7651af21426779b4823f2"
    sha256 cellar: :any_skip_relocation, monterey:       "231ead9fe663b8761739fb50bf3f803e4599f65cf5ac1cfd957f7efe18b0cc86"
    sha256 cellar: :any_skip_relocation, big_sur:        "323d3c1c9699c1297bc7428ce9006909d11353d41e4664bc49b0037f916e40de"
    sha256 cellar: :any_skip_relocation, catalina:       "3d87ad7fe2ff980c348a6af88c7e64b20a0315c9dd2746a372a49450e8cba669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5344ac0a47ed6a8395c23add388e88452ac7bb9b42b29bbdc7c524707c40e5a"
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
