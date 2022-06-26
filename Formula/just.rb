class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.2.0.tar.gz"
  sha256 "86cefef3db824d2a5190c6fcd12f295e1d62ac6002de479342a048403e06919c"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4808ce97d2c8943821c881741e9f03701b1a58fc4c5d9285df99cc3aa2a7d6cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e88b539190cc142229fcd7910ae9b698eadccfc22a0d3c6a94b0ae1393da20f"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9df80f42c1c642e94a32520c042bf2c0facc39f4ef24d04d61ef12d40db627"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb8a63d2101d7e96c20edb319d6cca211751fe86a0c372ae6d9a4ce47d59e1ea"
    sha256 cellar: :any_skip_relocation, catalina:       "43367b71610740a33257dca94c893db006e7bbd1cad8a5141b2ef76a6e11d064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0ac1dd6baeb81cf195551d781be8bf48c2d01d42b3bcba17b8bf8ca42c14f7"
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
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
