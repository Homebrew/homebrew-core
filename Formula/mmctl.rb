class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.3.0",
      revision: "0cf891b9f535570479e3a8b9c923212528f407fc"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739fb5aaf8f539f24121fc6f4c62b5559dd420e60b9b2faaf51643b0fe82d64b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0553bfa3d6fa73319bd5606d89840e2fad2342c2ea5f4e12c457ceae93467be"
    sha256 cellar: :any_skip_relocation, monterey:       "96c2817aa40cfe7b4e47a02bed72df748178ade837c9430dee5d5fe112838d57"
    sha256 cellar: :any_skip_relocation, big_sur:        "1df2a8eee2e76e2d1e587bbe659f85cbe35fb41cf880208edb37fe03803396b8"
    sha256 cellar: :any_skip_relocation, catalina:       "20950a639f1ac93a6409e25ced035e379a7d3a8bc2ac8e0d4479d3f5cba0dd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a539ef0c35e590fe1411d7a0bf4adc4ac1dda9f4e53ac745514c202a865701c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
