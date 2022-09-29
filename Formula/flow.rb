class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.188.0.tar.gz"
  sha256 "2b75858773a609c274c08c3977960ebb624115b65f83f8b1c705b03d41ac272a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ef2cfa0d74afa68814f8724daaf20c6a007b84435c61d4d6d2ba19637aa08ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daee2137c77e9b2499734a3c7ade7ce585064f22c8d96a1eb094e6b9da726523"
    sha256 cellar: :any_skip_relocation, monterey:       "db3e42db377b317bbb78d972a66a4810ed2f26c2d1fdee68117049464eca0c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "a164721aa8cf0fbd93ed8ea6230064015531155fdc6e261a45f1d27201d158ca"
    sha256 cellar: :any_skip_relocation, catalina:       "1c8efee0ed2e18aada844989a4a109a1ef9dccf48fc98d35f09696677399c1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75616e78f9dc0c40de70f741343506b80e5f37bde5a3719b8bb59d3f42d479c1"
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
