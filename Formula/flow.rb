class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.199.0.tar.gz"
  sha256 "a400832169d8017b2f07602b7c49d486a55d572c5e522fe168f5d7d091dd5c34"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87e103802f1478d7e24e992d515549a4b8fb4ebcabd61a5f584d348eed83ca3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28a50fd426b908a8b88e071872eafaa9ace44c5001c0377a4431df821c3186f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16d8222c46584d14f781a325cc2ead7c11d457cecf4832a8edb5709c5fefe4ac"
    sha256 cellar: :any_skip_relocation, ventura:        "eaaf38a93f1b9adbb4a7fa7a04ecf9f0fce888176859e308decfc16cf9f15853"
    sha256 cellar: :any_skip_relocation, monterey:       "244851cbf6a90a8f61db505ad20bd1020c1f1fa7158d4e4060f1db6c8ca1df2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "812ae8a96c374e325794a482a928aa7cc5d725b4679a022e6d4ebacdaa288898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c875bb5375baaca7d3a93698eac91be92c4fbde0de3379187bc8b08556fd03b"
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
