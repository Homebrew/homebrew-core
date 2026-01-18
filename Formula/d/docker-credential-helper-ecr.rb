class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "d4b5e4e08d444530726ec59e09057fc1558876ba62d9aa8a2a44c04fd5dffb71"
  license "Apache-2.0"
  head "https://github.com/awslabs/amazon-ecr-credential-helper.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73768a1d4d44a75a654cc72a354e35e0bc2b2421e5f2a4f06efe455aa2677516"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73768a1d4d44a75a654cc72a354e35e0bc2b2421e5f2a4f06efe455aa2677516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73768a1d4d44a75a654cc72a354e35e0bc2b2421e5f2a4f06efe455aa2677516"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e01e8ead98e3d9b572080917d570fb8613827ef933ab77be03b138135d147a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e7376b414398f0d44032ad150db33349889fdbb4a03d0d3ef47674a925bb90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "749747935788e4b951f33d9df4088e431724abe1de6a37003e1e41ca3b026580"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

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
