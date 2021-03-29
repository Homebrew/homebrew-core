class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.9.0.tar.gz"
  sha256 "877fdd517722ec1a554b046e1a9fd112f3503d91211702895c5ba12b29dcbcc6"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1eebf04d4decf6ce18204b0175439989c590e1e96e15569c65e12457a4bd4f5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ba638cbf677306d133c40306467bbca28cac9885491877bd11aba87a1c93ea4"
    sha256 cellar: :any_skip_relocation, catalina:      "a36550958769b325b8edb7463e038d6ef4f2abdfed66381f544469293bb97c9e"
    sha256 cellar: :any_skip_relocation, mojave:        "9694353cd6f0aa8570fb65cfecb9a18bc8b55d3bca738794f672f2da9a27e554"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
