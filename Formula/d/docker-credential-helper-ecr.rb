class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "95478189f2a3dc6a89f3f047348f4e64443089c0574f6ec0bd864ef44f098bf4"
  license "Apache-2.0"
  head "https://github.com/awslabs/amazon-ecr-credential-helper.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "ebf13cea2bc6f50036bb6ef25931f6e05ffb6aa08455dc951161ef5bb258ad83"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3000010b6a643b2487436072507381c715ac3ebc6ebe2825931cc744c94221b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3000010b6a643b2487436072507381c715ac3ebc6ebe2825931cc744c94221b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3000010b6a643b2487436072507381c715ac3ebc6ebe2825931cc744c94221b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76e71a84d6a81ad131757c28a45c80c0a3c71f324744ff9d5436a9ccdffdd47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "60e0ad11e96d6569ff204bd4e0f193c4954de1035538360627050f9d83664eff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "ecr-login"
  end

  def install
    (buildpath/"GITCOMMIT_SHA").write tap.user
    system "make", "build"
    bin.install "bin/local/docker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match(/^Usage: .*docker-credential-ecr-login/, output)
  end
end
