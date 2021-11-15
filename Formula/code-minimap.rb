class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/v0.6.1.tar.gz"
  sha256 "ec526e174634f865f144b306145631693ef6c85fc463189049d29c92a5f1d158"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65896dedff8b1f47a56a118eba430b2983e635650d4e3aaa4513a08e19fc9d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb2b39a8a79976931f805356dd7d53f399edfa08933ecab84829353cfb721b0a"
    sha256 cellar: :any_skip_relocation, monterey:       "18195d4ceed5557489b7d1bdae33d3d01af15f3211ec2dda8967f281678ce1dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c121e75de1556e987debfdea99956e53850096ebd4e4e92d65a7e126040470"
    sha256 cellar: :any_skip_relocation, catalina:       "58739e29a7c5a211eb68487fea0abac801eef75ebbc01fc6b0836230a6720359"
    sha256 cellar: :any_skip_relocation, mojave:         "11e218821612a7678eabf80f82911f8f61bcdbba4b5a5a18be7130714a88fde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6d712b06fffca95fe634af673502ec5100a562b20d92d0593182059c3b5933"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/code-minimap.bash"
    fish_completion.install "completions/fish/code-minimap.fish"
    zsh_completion.install  "completions/zsh/_code-minimap"
  end

  test do
    (testpath/"test.txt").write("hello world")
    assert_equal "⠉⠉⠉⠉⠉⠁\n", shell_output("#{bin}/code-minimap #{testpath}/test.txt")
  end
end
