class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "98225c1a77c24ddcc44cd17a4689ec593a8f4080161f08805a27170ab6d86dd0"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da969529b51f8df575e88aed98e84d5cc6db84e1dcce14353ae40966bb9fa3ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1040d9fe3189dc43729345632bc39b7287e694df5ac75cbc830055821d45fd59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58efe8006810f020396cd385dffc64175654e975ba3cec355018bec46e786252"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a7867985077a484febd578c27c14a5c6ff87e019945be98cce01fc53d1ab036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "732eca17411e7341c7ced8408c8c95110afaaae7f0121d5cf008196e1f876a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3f964157ed8d720e25d3b7f8697fb96624e4285bcd0a581847884429688bf19"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
