class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6067a2cb36f8b451878b4336e4bef202999281b6c31727bcda97f62cfb4aa19a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162b30db65989114c0d53c3866eabcdd14ad39e656e52968a602441dd7315af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "162b30db65989114c0d53c3866eabcdd14ad39e656e52968a602441dd7315af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "162b30db65989114c0d53c3866eabcdd14ad39e656e52968a602441dd7315af8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0698aafc16bf4a94fe87a73fad1845f6fdfc3d62bc256590698bed8958c365ae"
    sha256 cellar: :any_skip_relocation, ventura:       "0698aafc16bf4a94fe87a73fad1845f6fdfc3d62bc256590698bed8958c365ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b778b0daccf6fd640c2d3dc04355ed2fbb8791971d79cd4f4650c1a7b0a331ff"
  end

  depends_on "go" => :build

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
