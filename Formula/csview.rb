class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/v1.2.1.tar.gz"
  sha256 "1b2d399b00c0bf55b1029360c941ac8c81b04e0838d754fa01aa5dca07d7b761"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6eabe3868773925184043aa91ac8b27ad25897921225fe92dd4de219c697f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e33f00ea247e7b67c0d4a0f2e8bc06995faf44fe980470c28e2e3bbbfa87ae37"
    sha256 cellar: :any_skip_relocation, monterey:       "14ebbdd0d829687887071efbd15a2014f33d564ed9db96eda047992ed7448e96"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc52971140ceedbf35051fa80c6cc40e71d1bbe7a980af259029d5f849632b1e"
    sha256 cellar: :any_skip_relocation, catalina:       "989b3372b5d6468750be6ffad0568e14fe10708e182dfb6c881d03064c7d0cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f2e061d99ba1317e0933956db3065501bd8d6bd5d1bbe720a030f3674b7147f"
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
