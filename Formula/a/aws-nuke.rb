class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.68.1.tar.gz"
  sha256 "124179d55b69a7844109fe1ac4a7aa2b3058e4a917dd7975e8e327b588145da5"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92b2e3402ccbe0816194e8a83a961c6a09ab8f7c4561b4dd229d4a6ccca2afcc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92b2e3402ccbe0816194e8a83a961c6a09ab8f7c4561b4dd229d4a6ccca2afcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92b2e3402ccbe0816194e8a83a961c6a09ab8f7c4561b4dd229d4a6ccca2afcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab7060de642266d8ec4508ff6950e589503ad44baa1ae1d19bd6f1706edc4fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3ce8887afeb39e03b1deb47df8e5ce941d22623b222894e1aa07b5403e53775e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
