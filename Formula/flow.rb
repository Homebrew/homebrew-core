class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.187.1.tar.gz"
  sha256 "99c64fdb979338b37fbd0a81d8ae19a422d12375945b3d42a011bc480ca1e09c"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29deba8526a8223e74c6e4837070b319e0508a3c6819426af67a4606d648bc36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42eaa1d6b92d485f94d5e3192b8217c6fff6e31f30cb0b4498f70e388941635c"
    sha256 cellar: :any_skip_relocation, monterey:       "8bc2e4aca6c32d96636eb628104e8e6b7cc466de37c71caada5db316407ed1cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "05c00c578005b21df8b56cce2643620c4a3a16e6c735c1b60289073607ccce08"
    sha256 cellar: :any_skip_relocation, catalina:       "12f264c8904fd78bab64c676cf04f0f7eeaa3f7389400d659c27a39dc44bfd98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48eef49f87ef05f368ccace84db5c4c038e7e088e1e540c8df2c97a6bb265310"
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
