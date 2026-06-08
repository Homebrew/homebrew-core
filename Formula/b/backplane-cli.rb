class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://github.com/openshift/backplane-cli/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "b4371e7df535bf6ca73d2eeb2566b41765e789dbb0a19b17a72e9045945a63ee"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d6453b5cbe3f2d34a281fb94828ce0fc1d1c3fb078e4086268519e532169f02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30616edd646a02a9d42fbf65a5e55af4df071eb510d64e6276b2b827085d837a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bc4e587603850f7ccd24b089a7996d1f27d1c4995e38113947da74bc63f31f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc8b6db14a8e1384534e178f81c44f15c428a8e0f537d173026651fc4216d532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2103f8ee463337be45c92ef82f8a31a45aef9ca1ad42b28e6412c9c1d40dd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af06281dc7fdca1e58d83e88506fa2ad9ddaa28a2e4c0f4eb00aa273c9028cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openshift/backplane-cli/pkg/info.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocm-backplane"), "./cmd/ocm-backplane"
    generate_completions_from_executable(bin/"ocm-backplane", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm-backplane version")

    # Verify config set persists to disk
    ENV["BACKPLANE_CONFIG"] = testpath/"config.json"
    system bin/"ocm-backplane", "config", "set", "url", "https://test.example.com"
    config_json = JSON.parse(File.read(testpath/"config.json"))
    assert_equal "https://test.example.com", config_json["url"]
  end
end
