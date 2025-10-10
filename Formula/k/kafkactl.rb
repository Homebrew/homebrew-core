class Kafkactl < Formula
  desc "CLI for managing Apache Kafka"
  homepage "https://deviceinsight.github.io/kafkactl/"
  url "https://github.com/deviceinsight/kafkactl/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "f0834e3242dd0042f4864c463250cce2570ed44b0c765107b209062d2949561e"
  license "Apache-2.0"
  head "https://github.com/deviceinsight/kafkactl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f743760f84df97a659cb5823e7829881fa0e0d8ada33b600bf62a85e0ab14082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f743760f84df97a659cb5823e7829881fa0e0d8ada33b600bf62a85e0ab14082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f743760f84df97a659cb5823e7829881fa0e0d8ada33b600bf62a85e0ab14082"
    sha256 cellar: :any_skip_relocation, sonoma:        "07be75540175476f5cd379fe3402eb6aad08001c4afb39f5ecd91efecde9796e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51b2ed2c9c68c57b34af71d807518624a79d4f34c70f457f8ab7a0279dd0e69e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df9f346e6aee496ce7feb6e78501beddd3d1738909f2e1948b77d7f2f1487351"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deviceinsight/kafkactl/v5/cmd.Version=v#{version}
      -X github.com/deviceinsight/kafkactl/v5/cmd.GitCommit=#{tap.user}
      -X github.com/deviceinsight/kafkactl/v5/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kafkactl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kafkactl version")

    output = shell_output("#{bin}/kafkactl produce greetings 2>&1", 1)
    assert_match "Failed to open Kafka producer", output
  end
end
