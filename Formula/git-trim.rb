class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim.git",
      tag:      "v0.4.4",
      revision: "1f39d85ddb242e9933fba9faaecd6f423f2b6a5b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6dfdb2448ca4677fdb82fc5891d06c183a2a2f547a49a2b77440f5bfd81c72c"
    sha256 cellar: :any,                 arm64_monterey: "8e71172f77191b0c589baf6ffa0fadcebd000ee520c52e7a9e25b7bd46b63d4b"
    sha256 cellar: :any,                 arm64_big_sur:  "d56061ee3ee7fe29d8251e01594847829f4c7d7723c68c6e5ef04d91340fafd0"
    sha256 cellar: :any,                 ventura:        "aef855710926163ffbb0199727fc5dba7fade49d189227a0186809eacbace895"
    sha256 cellar: :any,                 monterey:       "8fc8fbc99ffc6282dec5cdcbda87cdee74c291d819c019cfa99bb5ac54ab14dd"
    sha256 cellar: :any,                 big_sur:        "feccd4f6c9c78eeef17226a3c6f4eec5eb4eb34db117bf1d4a66e32fbb08f86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02701a8187ade5a8a2adc97e1df38baecf7381ef38c9f7666aff82c7440a987e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
