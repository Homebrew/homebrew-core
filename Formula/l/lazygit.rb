class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "24b0ce4f98834f2b2df0a015a13d6846d2711eba8ae2c0e5612c84dbc55b4c10"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b6892673fee5636e855b8d144c2970bc3bcb4c30a94316088b9f599f67ffbba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b6892673fee5636e855b8d144c2970bc3bcb4c30a94316088b9f599f67ffbba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b6892673fee5636e855b8d144c2970bc3bcb4c30a94316088b9f599f67ffbba"
    sha256 cellar: :any_skip_relocation, sonoma:        "d04bf784c4badd52e45a2f9d9f61197b0f0868d6a63fd7ea6024ea83f63e4b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b400675b9a368c4e35a814238ab917a7f4565e98075f00e446d92e3a8416350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bfac6b1d0071f810a35e7d6fc41a4f276efdf9988e234acf6896c93bfb4f842"
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
