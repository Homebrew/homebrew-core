class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.199.0.tar.gz"
  sha256 "a400832169d8017b2f07602b7c49d486a55d572c5e522fe168f5d7d091dd5c34"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3fb8512b68e5d818f7335c87e71a56ce520a7a2d0828b4ffb143f20f2532810"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c559f428541a2fa9f52c027e80508d84bf91d5f0908a44d21f8bf714c71bbf94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cded4bdd8807f9b4b48b9d12205587ffdecb4845e3d7bba4359a0fb85aee88e"
    sha256 cellar: :any_skip_relocation, ventura:        "0ad63273aaa42c1e767b4b4445d1fd377257f6123bc42a282cefe2f8def5c7b9"
    sha256 cellar: :any_skip_relocation, monterey:       "5a1160b9bd1c4ecdd8a91a97457bc663610bd1650b41ace61fa273b7c732b55a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cef82119bead0547f696c972772ef89f32f392c4fa61a7f4b51cc46d11a6d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0828978fb8fc923a2b301a9f8b2b0b2030e5192163a6aef04e4d7f166f0628"
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
