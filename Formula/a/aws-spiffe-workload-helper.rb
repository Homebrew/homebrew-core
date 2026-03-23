class AwsSpiffeWorkloadHelper < Formula
  desc "Helper for providing AWS credentials to workloads using their SPIFFE identity"
  homepage "https://github.com/spiffe/aws-spiffe-workload-helper"
  url "https://github.com/spiffe/aws-spiffe-workload-helper/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "480071226243042f639422639edd38571199c4ab752f90f3ef71cdc71bef49b7"
  license "Apache-2.0"
  head "https://github.com/spiffe/aws-spiffe-workload-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8f0d08b54b3b9afebdcea300e7b8b815cc73207139c73d7bf7401d503098e99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8f0d08b54b3b9afebdcea300e7b8b815cc73207139c73d7bf7401d503098e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8f0d08b54b3b9afebdcea300e7b8b815cc73207139c73d7bf7401d503098e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b9681ce3e3137b5bcbbca25922c87f0659d537e867fe5757a73b69e19547b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77f121ce67cafbf8256ab11d73efbcba6d703202ae9d0a44324a3276ad38c4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7bf548d97cab892689d127a5284848748adbacf7f4dcc3f0e3eccd9c9d8bb57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"aws-spiffe-workload-helper", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-spiffe-workload-helper --version")

    output = shell_output("#{bin}/aws-spiffe-workload-helper jwt-credential-process " \
                          "--audience test-audience --endpoint http://localhost 2>&1", 1)
    assert_match "Error: creating workload api client: workload endpoint socket address is not configured", output
  end
end
