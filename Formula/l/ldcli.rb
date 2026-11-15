class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "ac06d967db75d1256cd73b88fabc41bdae20b57efeea148dd13611c9b740e566"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0013fb183656c7240e560cd14bbcebacf2319e8904b678c21f8c659c01103c52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d4c3f785c670b68276ddc6ff46f64e65bc4e04afeac0c2eb83d36a51c6b78f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ae2aa72aec5b87a5efdbacfd60d79d343242009212dbac3250994b5c5453715"
    sha256 cellar: :any,                 arm64_linux:       "2cb52f4d52275a16d688434feeeeb644e77d011999344170575278ed8b2a67a1"
    sha256 cellar: :any,                 x86_64_linux:      "b98da6cc7cecb326a08ac9867e9e34fe674503ab5ce31a57e5b0894fa321dfbd"
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
