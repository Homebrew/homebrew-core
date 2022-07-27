class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "d44d0058a87684db8c61a9952a84327f7bab102d6a4a16547f7be18b9a9c052c"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdcc9e52ecb4334c2f4f8da73a8aaf9ef1e3d948d3be34687e531d9734cd7eca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b5d095346ac0d96c3cf2878dab37dbcf6c6e6193862c60bb6de0f375c46f9aa"
    sha256 cellar: :any_skip_relocation, monterey:       "5ad6853ff2d82d58c5c0d95d03d5de5a2f3f76efe0283adf9ce7e3a806a2f2ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "582263f5aeb1a70a319c62324d47a5432cc6d85aafb07e8aad2f981f26f7e781"
    sha256 cellar: :any_skip_relocation, catalina:       "996726129acb0c6c602363b2864765f8cea3c3b3bf8976a33a33212366a64363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899b0f7b64c293f6053be2d747661a5baff2d9783b505dbf5b4d118ead2fb29c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}
                                       -X main.BuildDate=#{time.iso8601}
                                       -X main.Commit=N/A")
  end

  test do
    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
