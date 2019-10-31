class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.111.0.tar.gz"
  sha256 "8f7133468c23d58a51cba4236f7cfb87d5dc73822c303510842045aa6d951dcf"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0605711b9d19f2659a0b4eaf343b2328b30b64a62c6528facf7528090cae1a5" => :catalina
    sha256 "9979a58d292e8f3e5608144d5db3c512838b9524a49b314c8c78abf8d2136ecc" => :mojave
    sha256 "47811c7a499e44836a3d84f34db4bf0adea23a4cb5c5ca58a4769a65ad4904ad" => :high_sierra
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
