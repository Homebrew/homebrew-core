class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v20.0.0.tar.gz"
  sha256 "82b08a44f2cbde4b96aff0f77c3758b2e10534e5b017548bac9387f5b3d7bfa9"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96deffa4780f459d7333ede5a4a031043d1f8175f3f66c2600e17736f9c1f9a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96deffa4780f459d7333ede5a4a031043d1f8175f3f66c2600e17736f9c1f9a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96deffa4780f459d7333ede5a4a031043d1f8175f3f66c2600e17736f9c1f9a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "998c79b056c1b39c4108a1aa79b191a9c037a712b7eb41d9a9ad5e0b1b4688d6"
    sha256 cellar: :any_skip_relocation, ventura:       "998c79b056c1b39c4108a1aa79b191a9c037a712b7eb41d9a9ad5e0b1b4688d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61fd4019f9c0ffc61f182135da0b7d20cac908a8a2e2c4974417c7674bfc5c27"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
