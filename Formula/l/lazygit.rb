class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "4fec66f33609898dbceffc02a38375f5b965b68d0eaf3f5afbe1a44481a5c72b"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b070dcf7835e4b889cf570379e5b4287f9593d3e8a0f6b6ed5098f167349574a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b070dcf7835e4b889cf570379e5b4287f9593d3e8a0f6b6ed5098f167349574a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b070dcf7835e4b889cf570379e5b4287f9593d3e8a0f6b6ed5098f167349574a"
    sha256 cellar: :any_skip_relocation, sonoma:        "63bc6f8aebc85132c9ed24fab7e6f19ec0b95e9a7cbca1549837a12780f12cc5"
    sha256 cellar: :any_skip_relocation, ventura:       "63bc6f8aebc85132c9ed24fab7e6f19ec0b95e9a7cbca1549837a12780f12cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee9c1a96bdd15717d8cadb43b9c32247dd0db77b6493257a3699eafdb4c57541"
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
