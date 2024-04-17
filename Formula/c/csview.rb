class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "eb71b3e6442afa9a9815c9cac3808b10bf3dd0d2f18fc3daba84980375f42ea0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ce93c99620c8eb7319121b1d7658209f8958ede571513fdf8444a3219822529"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a466f587f7ca00394e3b988cf2966394afd1f4c293ecc17c4a73a15c6fb64097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4822d06a8f9fdafc0c975edc5ee0bdcf0c1cea4daedeed70d9d7c7070403069a"
    sha256 cellar: :any_skip_relocation, sonoma:         "67cdcbc1a2a8c851f665310fef6c0cbd44ff1aef33a277462a9770af1fe3ca66"
    sha256 cellar: :any_skip_relocation, ventura:        "6e5443004bdcfaaa36622275127cda8ee3a9f0054bfa0a2a6d6ee7bad3d1dc28"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f40ef983d71c388cacdbbe78350e3a54790a0e2c9334c3136a3b7bd0a12478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33953d72d1023ed56f354ecb9418b118f8f03dde00e1554f5cfc80b7ee884b9"
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
