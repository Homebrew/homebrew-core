class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "7f5abf6c6a9a6b8d2cb3004da030eab2dc1c97308f2fea9f40306b25ea415ab0"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74928be5a3635465d682b60983e281f650092d59552f7c2dd987bee43b6dac4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217422d83d46933b7d8260492cdac8e60499fcfee92754ee01854f5be1133863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c86a86ada37442bb1c0ed3b6113c5b9eb75428e9389c21651013834f0c29c489"
    sha256 cellar: :any_skip_relocation, sonoma:        "f14780d88d02addcac91f61d322c8ce348533441f9e1207f6c90395a51ec21a1"
    sha256 cellar: :any,                 arm64_linux:   "c4bbaba4ea534e7ae6f7481dedd22fa57d5631a1117dae884cecc7e572056d63"
    sha256 cellar: :any,                 x86_64_linux:  "56eeea0c4d578081564e62e458db6b01f306e8e53fbcc4b2b167a3ce54c584f3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
