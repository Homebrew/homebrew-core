class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/v1.0.1.tar.gz"
  sha256 "34df6838dd9407197511887cdc9b2a3ed08b4b508f9c6bb660def326ea953e8c"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5d8b3edfe9549584da1f2550bf57c6a9ed6d415bc7cb1a113d429154989c6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0f4600bb7c94e7c021ba27155f25ca4d3af4605cb02a59c09b789e681a23815"
    sha256 cellar: :any_skip_relocation, monterey:       "ae25c1b64d95399a046d79e1ad974e96c8578261b439496d04f6a5703ca8ecd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a7702a85d3752f18609707e4c65ee0330de495b9c4c994c2ed28b4cbce96a3"
    sha256 cellar: :any_skip_relocation, catalina:       "bfbf60817be5424b5f75a144b80d6da10e81a846b208ebf67c9073a0bb58a368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4098aaa0251e12198718faa550477c8657fc56694ed78f43fc7a5813ccf5207b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completions/zsh/_csview"
    bash_completion.install "completions/bash/csview.bash"
    fish_completion.install "completions/fish/csview.fish"
  end

  test do
    (testpath/"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}/csview #{testpath}/test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end
