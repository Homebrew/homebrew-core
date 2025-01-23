class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "dd3d6645ee429f0c554338c1fdb940733793ad915ae72653132664aa7c26bbcb"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9810c588501799830b9750d4c13f4de42fe484f44edb533fe5a135d62ffc1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e9810c588501799830b9750d4c13f4de42fe484f44edb533fe5a135d62ffc1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e9810c588501799830b9750d4c13f4de42fe484f44edb533fe5a135d62ffc1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b49a974046e6d3723c0e981c2a54bd8e155e550c5450fb60919a45a7261b5d2"
    sha256 cellar: :any_skip_relocation, ventura:       "2b49a974046e6d3723c0e981c2a54bd8e155e550c5450fb60919a45a7261b5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1422255282e16c79296181d1b683927e7f428034954160df47b440eca1ab709"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
