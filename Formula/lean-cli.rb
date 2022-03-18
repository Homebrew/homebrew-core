class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.29.2.tar.gz"
  sha256 "b5d39383335ced9f7b9adb5bf9701cd3e4b4df19bae251b8a603c71b896ec32b"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2068012dbe4e9ba5a477728c73c1d1027c9bc2143bea22efac9f46a6371d889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "938d04c38bd74357e7881fabbc8a123d39ca7bb5f64f7a03c90d9b162ac057b8"
    sha256 cellar: :any_skip_relocation, monterey:       "b99aa01419ea57946c7934481737de4ba380e67ed9d280f0babac885519de406"
    sha256 cellar: :any_skip_relocation, big_sur:        "b51cd54264423bb54aa14cb70d609f0a628c9e50ddcfb12d7af7c9df42c5d96b"
    sha256 cellar: :any_skip_relocation, catalina:       "376934101ecb42fa60761fe9f7c4848fe363588b7262ccbebf2584d915e8018b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "099834ac3c6bc5ac2d6157e0bf6a9d1b219daf6316cc672810deeedc26621301"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please log in first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
