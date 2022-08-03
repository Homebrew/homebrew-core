class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.184.0.tar.gz"
  sha256 "8ea006c6a9f656e22099589ec7a7a9999942a966abbd52b707b5ecacb4c480d1"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8def2c1de1b2e8167cebdc619b665228cd0356ddde1cf9be3e637b44add026d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8cf7cbf585504b771907a877214dca8bde67981b813c6e02197c0aec04fcfa7"
    sha256 cellar: :any_skip_relocation, monterey:       "bf04f8b2365be226484dbe56fbe188ec601b3730b9dcc3054960a47061221860"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac395b57fa22d01d27aadde8bc1733dc5e9cf75c7ef83fc6ca1d1e73b979c41"
    sha256 cellar: :any_skip_relocation, catalina:       "5e96a4e6c2498c56fa0b0267e1d049c177ac9bc0ea57a4e08716951cb753968f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d23f01265bdaf33b15405e0185ecf876b455994ca6ff314e8050e64220bead6"
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
