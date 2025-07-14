class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "872f612d8ff2ec294024c58b5ca452bebcd9eeceb29e105e159e5579ec6056b2"
  license "Apache-2.0"
  head "https://github.com/awslabs/amazon-ecr-credential-helper.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "310ebe1f0703c4029bc2d6ba98e6d687097027a27fdecaad0d5b499a73a720ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310ebe1f0703c4029bc2d6ba98e6d687097027a27fdecaad0d5b499a73a720ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "310ebe1f0703c4029bc2d6ba98e6d687097027a27fdecaad0d5b499a73a720ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3779569bb4207c50dc2cdbdfa61636241e9bcf04186d99667b2301b6150f90c"
    sha256 cellar: :any_skip_relocation, ventura:       "e3779569bb4207c50dc2cdbdfa61636241e9bcf04186d99667b2301b6150f90c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af285a04fc0326dae93ad0fa43640e914b3fb360d148d0f5def253d272815bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d8cac37394c8753de28ee0befb678fb8a3cd2e2cbbd4dfaac0d46b05b52e54"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

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
