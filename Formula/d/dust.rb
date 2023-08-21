class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.6.tar.gz"
  sha256 "feede818e814011207c5bfeaf06dd9fc95825c59ab70942aa9b9314791c5d6b6"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6d72ba4c858b0e44d7f95713b78070610aebcec83ea8200ee6c8ce465144480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ce635f5ac7ae65863e2eec8f928d980f4fcc558096f738bbee3afe6d0009d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f083d4c18e1014c826927da64b5893546eafb5597e02f73adf0f8de4eb93f361"
    sha256 cellar: :any_skip_relocation, ventura:        "4fbdda7b25b1c9ec1ec4110b1c6589ad998fdc914921a66d19ec76b1d131d54a"
    sha256 cellar: :any_skip_relocation, monterey:       "1c6a6a5305b711c33a23fc1dd7311ef479767be4046dc99373558c92eabe3ed6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d93f784924a5b7bfbf9a51f9abf37752af93e6eea61a02aa257b893c86ce282d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37c6d9c30ca6d383019a6da38c25ea8680b2e62ed4438dbfa76a9abb77be128"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https://github.com/Homebrew/homebrew-core/pull/121789#issuecomment-1407749790
    if OS.linux?
      system bin/"dust", "-n", "1"
    else
      assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
    end
  end
end
