class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/0.237.2.tar.gz"
  sha256 "d18ff5900898ec4304c54129e0493cf198db2e5b10e91f25273348e93741a5f0"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f686c884a1aec4f99dca6b4f68d7e1a369c97eb3f311bcb3cfe87b2f8fd9ae89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "216da04c7d6ae7679c460bed4c9c7002c599507ffd6b2b6136064509732333ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ce31bda3c71b644e9f8a0229a09ccd4a295f8c55d1d4b70ce2b4e3be2fd660c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5660ce52133c249c59dda25e6e7104ad0e3aab1506d6c18d319fcc911dc5eaf"
    sha256 cellar: :any_skip_relocation, ventura:        "31d123ddb8be08f0d5d8f2381d8c59f2ea58110e3092b8dda2a980908aad5035"
    sha256 cellar: :any_skip_relocation, monterey:       "0efe1eac0f32b1552091b63dcd1183314e10d310c70c7bc7463d013cb2d5c6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "597e7c75fdea8e74bd51c0f175c0f3c4da8dd82f581cd355ac22988e56a52d5a"
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
