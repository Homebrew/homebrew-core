class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "306d7662994e06e23d25587246fa3fb1f528579e42a84f5128e75feec635a370"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbd946a04fb7affea1dcbed915c312812b41bb2baa53d5cd21621e86bd85fdbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9571530e58a9248c63ef228c24b2871366a93bc40819f56f3851e11b70cc122d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b6fc1b116843a790e8cc6e2fc5eefb0ec1e8be6e468aeea9843bf089cf8abbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "53da052d53334f6f60dad0add170b261044e50de2af61559ea32b5bc3487f816"
    sha256 cellar: :any_skip_relocation, ventura:        "11bd142cf3d824bb24cb1867ed9a58960bbdb9b1ef23d4bd0d5edb443e80dd16"
    sha256 cellar: :any_skip_relocation, monterey:       "37e345f476ec684f75a111cbd51d6fd9e816b946fc3ef41abad27ccb7b814903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9362fedd45bacbe528d85a3995a0069e83f36fee622cc2e732c1b55a7f53a16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install bash_completion.children
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
