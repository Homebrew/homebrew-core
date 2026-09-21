class Kpt < Formula
  desc "Toolchain for composing, customizing, and deploying Kubernetes packages"
  homepage "https://kpt.dev"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "334bfa273fd57af06324f30e7447306c93b03d7146ddbc2aae8b63dd52b6fc4e"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c547a2ef4a3562dce2490eebfa439b3069d084f82b96878fc2ee8f185fd29782"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8f91bacc9cacc9916badc9b09c6be6c3a98e7dbf674e774363b9be58fdeba3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72cbeae31800fb7c6a954941ecc682595d7c4fca54cb9792a068135fe7cd3f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "365d7a725336405307be09e161bb8f7632e3e416d38215d84ba9b7cd219160a3"
    sha256 cellar: :any,                 x86_64_linux:      "f482d3f746b0eba552df1c80006b0faf5fa55f5b8e68217a6a38d438ab800481"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/kptdev/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"kpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    (testpath/"pkg/Kptfile").write <<~YAML
      apiVersion: kpt.dev/v1
      kind: Kptfile
      metadata:
        name: example
    YAML
    (testpath/"pkg/deployment.yaml").write <<~YAML
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
    YAML
    output = shell_output("#{bin}/kpt pkg tree #{testpath}/pkg")
    assert_match "Kptfile example", output
    assert_match "Deployment nginx", output
  end
end
