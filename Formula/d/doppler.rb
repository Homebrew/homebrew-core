class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.74.0.tar.gz"
  sha256 "7174cf7c963e939180cd07e325a163e2712ad1346b2aef09a267f0328fd9ee1a"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cfea3001c57cb86c423d2b97e5800251dc831524cf672fca3fbf390dae5cd7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cfea3001c57cb86c423d2b97e5800251dc831524cf672fca3fbf390dae5cd7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cfea3001c57cb86c423d2b97e5800251dc831524cf672fca3fbf390dae5cd7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb5846bd9ddc86b465a5e5a01ad5c10cd65df1e69a71bb35b5429e177714db57"
    sha256 cellar: :any_skip_relocation, ventura:       "bb5846bd9ddc86b465a5e5a01ad5c10cd65df1e69a71bb35b5429e177714db57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa6ca27a3c2df4c1bdda56f9d72a66bfe343fc3147da3ce00d89fad72d21b436"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
