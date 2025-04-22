class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "5f74970a7303f22e5cb47a99b0480c213e280c10585edbf6ae16240fc4e55fa7"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1df7292563ecd3b9a1f625e18204b0cc93d40810790070ee78272e30f2992c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd1df7292563ecd3b9a1f625e18204b0cc93d40810790070ee78272e30f2992c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd1df7292563ecd3b9a1f625e18204b0cc93d40810790070ee78272e30f2992c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfadaa6771631f3604fbdc944b008678a969e3c117b4e83b0119b0c7a15b78fb"
    sha256 cellar: :any_skip_relocation, ventura:       "dfadaa6771631f3604fbdc944b008678a969e3c117b4e83b0119b0c7a15b78fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c751d76d97c70fe82260a4a90aae57aa88ce0004bd9ef8379bfdbf0dab3e5f"
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
