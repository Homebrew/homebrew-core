class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/v1.2.2.tar.gz"
  sha256 "c8c4d1207b225e4257f301af6333d28cfee611781cfa51bf8227b742b043105a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9057b70f320c95c241683e8ca4a6bb7968bf51c75ecbe0c2a97f204db309085"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddf8e67b24eba0d523039711673f0acaa4569c4994f9d423353e5b6b67e8d595"
    sha256 cellar: :any_skip_relocation, monterey:       "45b6f3365cd1e89b7b3c8d520d7991a9bfcb74fb32d174380d8dce2b21315ca1"
    sha256 cellar: :any_skip_relocation, big_sur:        "908eb920f858656aa4628b719b7702a0f5567e6be30ded6af1f997942f1e90ef"
    sha256 cellar: :any_skip_relocation, catalina:       "74010e19e076ab175e05522dea27eb82d34e800d8fcc07c8a70f98e2fb1e34e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f86364490bd2f8afbc273e65c431981b2a4d158f520923ea93d68799954aafb3"
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
