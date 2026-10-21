class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "151a973370d6e25c95e039f96b299ea1c838538eb116cba85b3eb7295c9b5a17"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "203ea08caaf1524d4e93005b0c623e19387f9f28e0962152a1e34d2e2832bd87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb57f8a893226767dd2d900846e960d9d93e050455159174174f4ce5ae1f4a4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5fa638a6bd2fd68c5b851022e041681fd5723a35098f41b01026ecb0899239d"
    sha256 cellar: :any,                 arm64_linux:       "07e86cebebe39c5ee3bdce1f476c5870bd746abecf7ea5aaf39a8452d4ab7423"
    sha256 cellar: :any,                 x86_64_linux:      "b8917602fa997da0af519bbcda81a44b8428a647b5860d38e2e460df3f263741"
  end

  depends_on "go" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
