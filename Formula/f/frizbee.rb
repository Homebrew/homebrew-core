class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "72ca8ec701036c925e587e15e7a05c2f7cbd219f2fa36d7945c064a47606b911"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de1ee319f3d51c1d41ee8b66d88ee57f26b61df700971543e7a5e224ab21ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4de1ee319f3d51c1d41ee8b66d88ee57f26b61df700971543e7a5e224ab21ed4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4de1ee319f3d51c1d41ee8b66d88ee57f26b61df700971543e7a5e224ab21ed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "699788017804b1137bc8fc7339b0428cd3572865c58ba2332042105e619e5fc7"
    sha256 cellar: :any_skip_relocation, ventura:       "699788017804b1137bc8fc7339b0428cd3572865c58ba2332042105e619e5fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d376457880a10e2f3a87ba9a232b7a55780598ef696a515ceb0233808a56f54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"frizbee version 2>&1")

    output = shell_output(bin/"frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
