class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper.git",
      tag:      "v0.6.0",
      revision: "69c85dc22db6511932bbf119e1a0cc5c90c69a7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "306aa5e8086723bdf6cbaa45be2c74291c9e9df620cb7f451fb485a65123022a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0d768a76a10449f70e88d0b25dd11dc9b8f8149f6b3c153fa93a018d2375fe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfd6561543c85f32a1eae09b00e0b0ea8ccdeada1073227cc87fed3916b40bd5"
    sha256 cellar: :any_skip_relocation, ventura:        "d3f95e69ebcb56bde01325a671d8983eba2edd259ba718ae7b39f1968232244c"
    sha256 cellar: :any_skip_relocation, monterey:       "e41c402435c1e0a079461dce61a5ad1a695ab3af689bae754a3e7ad9328583e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c15457c2a829da7ac19e2a52aa1c64f5199feb4cdcd4998df46ba45676c0db9"
    sha256 cellar: :any_skip_relocation, catalina:       "4b6a17ed414ddad4cb9cba0e23eb0e427addaedb5dea660907ef0339967abee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ccf231057d1fba63bb6b99d62693989df43125e25028bff5fdfa88e7c7cbb7"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/local/docker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match %r{^Usage: .*/docker-credential-ecr-login.*}, output
  end
end
