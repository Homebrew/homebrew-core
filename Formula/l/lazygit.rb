class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "f78fca0ddbff18f7a5a8d04ba582354b98f2e42d181421090638e4ecfcdfd33c"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2843225fba69f1a2eef078bd7e45f251d9d09768d812d6a2d38ae786e6eb7442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2843225fba69f1a2eef078bd7e45f251d9d09768d812d6a2d38ae786e6eb7442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2843225fba69f1a2eef078bd7e45f251d9d09768d812d6a2d38ae786e6eb7442"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc62102ce042affe16e1700cbdafe45c6344f932d8a45a63e5d7f4ded9c24696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8acccd38a2aea178be53d30b86981c0ef3cce6875e8e617c860abcb44fd4c5f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33ae2332b07f1547508f4e196542727d2c9e5c7d42bf41723c5390f0c6f9f73"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
