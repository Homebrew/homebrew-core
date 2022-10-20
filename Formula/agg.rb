class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "51cb553f9adde28f85e5e945c0013679c545820c4c023fefb9e74b765549e709"
  license "Apache-2.0"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b851b428d4dfa04a0d74765bc0968889cd944da2022c56ccae9b9d8dcb7c3849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89b40ebb79fc932d8603b77dfe70deef6c6263199192a29e7567f6d6d1f50e62"
    sha256 cellar: :any_skip_relocation, monterey:       "1232bc241ed1dc1c93a0c3864ef77380effc03cc4d4f4630ea2a73601a8996ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f3b4ab924861361e27e146c20730598150fa4fa6850091ce545111a571e9079"
    sha256 cellar: :any_skip_relocation, catalina:       "cbd6e442a0513e79a5a556c31faa3a9a7495b22f0f7b48474413d696831bbb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25cc79f6c4a724ded244abd5a54f45948bebdf20d9a7f135996045789cb6b609"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cast").write <<~EOS
      {"version": 2, "width": 80, "height": 24, "timestamp": 1504467315, "title": "Demo", "env": {"TERM": "xterm-256color", "SHELL": "/bin/zsh"}}
      [0.248848, "o", "\u001b[1;31mHello \u001b[32mWorld!\u001b[0m\n"]
      [1.001376, "o", "That was ok\rThis is better."]
      [2.143733, "o", " "]
      [6.541828, "o", "Bye!"]
    EOS
    system bin/"agg", "--verbose", "test.cast", "test.gif"
    assert_predicate testpath/"test.gif", :exist?
  end
end
