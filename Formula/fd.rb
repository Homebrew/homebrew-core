class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.3.0.tar.gz"
  sha256 "3c5a8a03c4f6ade73b92432ed0ba51591db19b0d136073fa3ccfa99d63403d52"
  license "Apache-2.0"
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89f7c27602bf8d146b8cbac9545bc25089f155e193fd30a3812cf17478937b5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "686721369e2c5b542853d31948b45798ee80bede3b8b9b08f782819d1c9d9927"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a165261b87aa903db6c04c3f663998259c2753faf38cd091c4ff9a2ca485f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "328371581788b9bd7024a560e2adf70d08b62ebc183c81db3f1624b96e379d65"
    sha256 cellar: :any_skip_relocation, catalina:       "310755363e8ddb08c0662747adf686ca18fe3bd7dc3fa2aa983b7d4e160efa50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c21c8c076f322a5a513f0d0dda9ce9a48057a7945f222ebaadaa0bfc6bf3db7f"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/fd test").chomp
  end
end
