class AwsSpiffeWorkloadHelper < Formula
  desc "Helper for providing AWS credentials to workloads using their SPIFFE identity"
  homepage "https://github.com/spiffe/aws-spiffe-workload-helper"
  url "https://github.com/spiffe/aws-spiffe-workload-helper/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "9ff2c4f824dd8715e5eb5c186a9bf877887aff1b3bef153b653facbd833040ca"
  license "Apache-2.0"
  head "https://github.com/spiffe/aws-spiffe-workload-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fef17afdd9796fac88f78499fb895f8859f8fb7e866b27314ec7dcdac96eb764"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fef17afdd9796fac88f78499fb895f8859f8fb7e866b27314ec7dcdac96eb764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fef17afdd9796fac88f78499fb895f8859f8fb7e866b27314ec7dcdac96eb764"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1871af561bc24aed02cad20fc83d633190eb3f2b8a3fe4476c8d945e9c096f4b"
    sha256 cellar: :any,                 x86_64_linux:      "254a0144af1ab9ba1ce6e83dfb6995acf69d7da5aeb240f2882bd50a28fd09ec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"

    generate_completions_from_executable(bin/"aws-spiffe-workload-helper", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-spiffe-workload-helper --version")

    output = shell_output("#{bin}/aws-spiffe-workload-helper jwt-credential-process " \
                          "--audience test-audience --endpoint http://localhost 2>&1", 1)
    assert_match "Error: creating workload api client: workload endpoint socket address is not configured", output
  end
end
