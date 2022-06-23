class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.181.0.tar.gz"
  sha256 "dc3806bcd771178ce91166c744125ab8f6ba5e753c9ba3403f4b8bcd3e921336"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "869ce2da4c61c8418deb824327d99d245783a426880d2ec60e77d09c5ea5ec43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cabda520d0a8eff76a778f03bd53bd160e1312499508ca93ffd09d826de9842"
    sha256 cellar: :any_skip_relocation, monterey:       "f1f888be480411c298d3d59c4ab21020f184c9959d17320ba92c1dad4ea5ff1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "66ad65c3badf61c313e0cf63b4617dbece2953a7e5886a0f4c495b9fdf5751f4"
    sha256 cellar: :any_skip_relocation, catalina:       "a4e410789bd5f68ae4b05c0ce4626279e8f068181b0ffde2712a963dc0b3a122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ca6c05fa37d4cbf33cd73e2f63605e105a51f9db8e9ddaaf2d4771079519b1"
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
