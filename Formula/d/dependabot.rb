class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "3e11cc0b09f7af3fd9a66b87a8955ec3bbe71d8585d010c9732d211e417c5591"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c42846597fd9bc15981e9b43a10d6d25f724aedbcc86719c212d1abc51d112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c42846597fd9bc15981e9b43a10d6d25f724aedbcc86719c212d1abc51d112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c42846597fd9bc15981e9b43a10d6d25f724aedbcc86719c212d1abc51d112"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9c42846597fd9bc15981e9b43a10d6d25f724aedbcc86719c212d1abc51d112"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d434255a543e2fa236d3efaff094c73331aa8e6ff916394250ca2d9aa85e7c3"
    sha256 cellar: :any_skip_relocation, ventura:       "5d434255a543e2fa236d3efaff094c73331aa8e6ff916394250ca2d9aa85e7c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea4479c43a619def9abbfc3b1c5940a1ccb7e7631d35ca12b247166f02c84e49"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
