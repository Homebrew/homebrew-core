class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.299.0.tar.gz"
  sha256 "e404a8c833bc389d5d4a6ecc027211524a7428585e61bbab92e0ef422edad523"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eabf2f5a9d3329623f30fd183f3097ab9d9bfb1261761b0b36d8ff3100cb976c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9742117eca17d15cf6227ac8d36d5a93024bc6a653725074ecda36ff91350577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66912974891e8b915a1b221f50a4a6a6c2a0af50f51cffbfa1b09dd2f60fd37b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee7815c3e33a31fec5bcf111f59a46e4dafd4d7f9d1df4b26f9a2818705eeec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f4e19dfe365d49f1fe95e4e35f20003ca4e82b2040f6c022b3f820f876b2fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7905ac6d33879d946931f49a77d6061ddbf6a558cd84363a3586499a283bb66"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
