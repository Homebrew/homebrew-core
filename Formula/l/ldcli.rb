class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "ac06d967db75d1256cd73b88fabc41bdae20b57efeea148dd13611c9b740e566"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e085b5ad58a9fdb9a73b335e744fee802b30b84d30cefed2c0cc43eedc330eca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5963a0ae20ced438875bd4cf0408ef94d81df01a9babe26d2d7d36acf8fc1e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8811cffc3c6522381039d3fceb6191f9443e3f0e6b4d77bb2f203a87685ac0a6"
    sha256 cellar: :any,                 arm64_linux:       "aeb754fba50e134d5bcd9c6242e7ef145d0a8225895a0a1c5e996601320209c8"
    sha256 cellar: :any,                 x86_64_linux:      "99863ff1068ccb967f6b2f4a8f2c1baa561798be3acdd5084566593de0878548"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
