class AwsSpiffeWorkloadHelper < Formula
  desc "Helper for providing AWS credentials to workloads using their SPIFFE identity"
  homepage "https://github.com/spiffe/aws-spiffe-workload-helper"
  url "https://github.com/spiffe/aws-spiffe-workload-helper/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "d670012e9dac1b2fdadf2d2c24c0844654239796ca71898b1d213cbca419d6d4"
  license "Apache-2.0"
  head "https://github.com/spiffe/aws-spiffe-workload-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ff51eab0a8f05b348bbbd5cbc3716d66fc1ba822da8dd0f12750521fc2fea62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ff51eab0a8f05b348bbbd5cbc3716d66fc1ba822da8dd0f12750521fc2fea62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff51eab0a8f05b348bbbd5cbc3716d66fc1ba822da8dd0f12750521fc2fea62"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a905126844616c11ebaf6b08b2e2c0f30c90f4ef56e0c0b00126db9aa928ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b7d29ecbf03bc4e70d824a211f7efbab2d6c951b244bc497cab721bc5074fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ae53213ffa8c3cc2507d8b922edea19f64756b7d54c34b0258a4e231411f01"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"aws-spiffe-workload-helper",
                                             "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-spiffe-workload-helper --version")

    output = shell_output("#{bin}/aws-spiffe-workload-helper jwt-credential-process " \
                          "--audience test-audience --endpoint http://localhost 2>&1", 1)
    assert_match "Error: creating workload api client: workload endpoint socket address is not configured", output
  end
end
