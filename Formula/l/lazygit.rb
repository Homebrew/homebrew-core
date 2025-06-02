class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "467fb3988a375dbfd9288beaae89205d39795a0fd7f156b813d52bbcb57f3506"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e42a5e6d5da3df8e8b3a40d4fd2728f1e76a8d18b3b5ca9f2d3dc2e55c399c8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e42a5e6d5da3df8e8b3a40d4fd2728f1e76a8d18b3b5ca9f2d3dc2e55c399c8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e42a5e6d5da3df8e8b3a40d4fd2728f1e76a8d18b3b5ca9f2d3dc2e55c399c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "973f2879428d835eb3dc72daac7d5c7b41fcbfbfb178ef00ba62453b95f0517c"
    sha256 cellar: :any_skip_relocation, ventura:       "973f2879428d835eb3dc72daac7d5c7b41fcbfbfb178ef00ba62453b95f0517c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c009000f1ff8e8433f19c87c3a033bd013012ecac287f14e3f923879fd9f973"
  end

  depends_on "go" => :build

  def install
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
