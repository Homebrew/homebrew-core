class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.14.tar.gz"
  sha256 "1b14a1c8d5143cc42bc912eb047f915df012cb54dbaf51f6a042afcf491c5b7d"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c941634e07c21d8f1b8ba7173dc64f424f95a67b118cbc186009a6c43b94987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eeb3ef218aa6c4c08ed7931686ec499dd0fa6519610a6beac488774696aa717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f48d38f7881447e6376ef3d774ff7d47836dd0d0c1a8f0769ef21c3166fa49b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a817b89144b26bcc88cf6d1bf320f8dabfd91a8bd74f9b19de123e4d5b84fa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587c172ba6d848a03c503754c1d9de6de42f8850d931cf6f0db63a5c5bbed2ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be41a528ae2e70d590be44cdb39758293074bea1c39f6fb93c41dbf429f9ae26"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    # Upstream suggested workaround for undefined: securejoin functions
    # Issue ref: https://github.com/unikraft/kraftkit/issues/2581
    tags = %w[
      containers_image_storage_stub containers_image_openpgp netgo osusergo
    ]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", shell_parameter_format: :cobra)
  end

  test do
    expected = "finding 1 unikraft.org/helloworld:latest"
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
