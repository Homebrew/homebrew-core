class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.33",
      revision: "e1259de78e866fda234012d5a3734edef3cf0609"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40fa4083313a7f1b91bb8614dcbdb25c71eae0a3b2f091e58d84312ad0adb076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d3a0858e3944b2e0531618671f94faa9764b1526731775401b66cf204df1ef4"
    sha256 cellar: :any_skip_relocation, monterey:       "93909fbf95e0bf58e3c5f2bcd69c52cae883cfc46f55ae066b5c582b4ba72abc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c00bb08f76d231a4be8186606f32a821b7a1f87c9b0881b25063a18a9f8de58d"
    sha256 cellar: :any_skip_relocation, catalina:       "34452924c4fab10a738b20e5625dfe4fa36322dbfa1da99b18b0aa852b66f838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d116a9029515cd087222b79906ab32e2fba60e576a5c761c32a26bedde4b6b"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
