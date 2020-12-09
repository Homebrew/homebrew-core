class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.138.0.tar.gz"
  sha256 "f98e813a66186938666d3503f5aa4717c676b07d3fb7e5dac260029135dfbb37"
  license "MIT"
  head "https://github.com/facebook/flow.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f311096608baa2a1240f49fda7aceff82ad46b2f7f5726881cb806276aeebc31" => :big_sur
    sha256 "b618b3c14d7320f7f1d373cd124753cf6087f83fcddc8c1d669b7221737df046" => :catalina
    sha256 "389f59a45920687d79760978e84dbaac6428ec77afafb6956e0674c1026e86ea" => :mojave
    sha256 "169ec8af94a62bd05bc75b56fe21395f2421d20bf094eb4afa17381514e60860" => :high_sierra
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
