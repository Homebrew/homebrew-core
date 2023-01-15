class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.197.0.tar.gz"
  sha256 "f62245ac39d344e6372ae497e532dc3e26bb898cbd7abae4abe83f5add9ad20b"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c63f21a6f82743fd62be3ae40b3792c303b72609a7193674f40fdf6ab17cfef6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "005e9c3ff9621e77db9298a87390d7795fa36e58dfaccccef3d0df16718ad2fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75fa438432a835201dc4d40b29a78139f424c8e0d41c91d510bab6be32cb672f"
    sha256 cellar: :any_skip_relocation, ventura:        "e48066b77e1fcb1f90af29130eca49d045b7fcef7eb474fe66bc337bb2b0efd1"
    sha256 cellar: :any_skip_relocation, monterey:       "5653d66ac759f7b32564aaeea037aff7a77493d064947a8d3030d3c6d49b57dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfd8db27a70a461c76201073e70206bf3dfc6796a760784067d09a0608f6ade7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5196c32e836b9b402a950153a3b2580b712ddb6f8f0b91aa1b5332d446a6d636"
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
