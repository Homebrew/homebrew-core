class AwsSpiffeWorkloadHelper < Formula
  desc "Helper for providing AWS credentials to workloads using their SPIFFE identity"
  homepage "https://github.com/spiffe/aws-spiffe-workload-helper"
  url "https://github.com/spiffe/aws-spiffe-workload-helper/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "d670012e9dac1b2fdadf2d2c24c0844654239796ca71898b1d213cbca419d6d4"
  license "Apache-2.0"
  head "https://github.com/spiffe/aws-spiffe-workload-helper.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79e7043c7acd958256f00e7365f673d48decb5cfd54382706453cbd127b19a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e7043c7acd958256f00e7365f673d48decb5cfd54382706453cbd127b19a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79e7043c7acd958256f00e7365f673d48decb5cfd54382706453cbd127b19a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "632a7ebbce68251df65c5faa8ee27d14fe84865d53f25b9a50aea0c2e87e6e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "253295c66bb9b25829b094ed0b16edc17e69b4e6fc28b4f36fd489a2be0c07af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa57b54f65b1d74543c5502a59086abbb727d0903a77c07e31bd3d5cd99b0b0"
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
