class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/1.0.1.tar.gz"
  sha256 "261532a3b72b34a79df01bb0c4a366bcc3fd870c5706340fec260faebddb42c6"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eacf03d4ed4e8393f0b2e72227cf5f2cbe8e18cbc09c453a0e3fd1e29918e44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767c6c57a0df19b6398960126af54e2955bd8414582fb5e66a9e112b6c36932c"
    sha256 cellar: :any_skip_relocation, monterey:       "1a86cac989f21d897e4b020292e70ea0f72617cbf9b2dc2f20991232e6e34ea0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb09678eb5dd26921a094c027999d22545d908189afc18bb5c1cf9cebd88e6ad"
    sha256 cellar: :any_skip_relocation, catalina:       "3899743e826703e8f5c8744337b2287e19ca2ab8d98c442fbf34483ff7096ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f9ed76ed8f0a1d3ade667f102f627b8789920696a145fc75da4870caf9cae6"
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
