class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.44.1.tar.gz"
  sha256 "02b67d38e07ae89b0ddd3b4917bd0cfcdfb5e158ed771566d3eb81f97f78cc26"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bcf700102ecf5976c0c930f8c713f4309e632476a5f72d2c84e64abcae9bd73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bcf700102ecf5976c0c930f8c713f4309e632476a5f72d2c84e64abcae9bd73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bcf700102ecf5976c0c930f8c713f4309e632476a5f72d2c84e64abcae9bd73"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fc269661eb5372083df26bfbe811a7242a70bd5a5a4dea0e2f442a529136961"
    sha256 cellar: :any_skip_relocation, ventura:       "5fc269661eb5372083df26bfbe811a7242a70bd5a5a4dea0e2f442a529136961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf81243a38039594e8461d3a209f1bb49b1dff81fc2d871f28ed2b761b982d00"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
