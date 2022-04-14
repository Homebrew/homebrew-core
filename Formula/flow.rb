class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.176.1.tar.gz"
  sha256 "fa7e19752b852b2688987f440e425ba4e4fd78e121acd22d878e6834930e6275"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "746aa0908da775963292f265a307fd04b73e271dff701077d915e6a01dae5b91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b41fbf7639c8f4d4fa11879d0206a515e4f4b214c3f6cad459d1c8fa5b63b138"
    sha256 cellar: :any_skip_relocation, monterey:       "57354909b4e9c641dbb26c507321c688a91d601eacd02cb6028e511c30a3782b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6555e4386809a239f4aecc599df05b132652400bbfa028d050fd5229e41daaf"
    sha256 cellar: :any_skip_relocation, catalina:       "0167e6cf22372bacc58d9cdd6715c8fa4f4dc389c4ad2ca31de489a2143d417e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4768de48bfc64a04b2919d5bbace82314ed58662999151fb16c75c680053e53"
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
