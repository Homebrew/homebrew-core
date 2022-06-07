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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04e5ea0120e3f7fc82748a7a76e0fa7b74b266c1dc3906de1eb15b2d3be9e95b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ba8838fba8008c13eab1584b0c793dde3056d8e6aaabb25b622461eba910942"
    sha256 cellar: :any_skip_relocation, monterey:       "5b8acfc95b569fa6514079f6988dbd8299c63428b1f77d2dce6566ae992da76a"
    sha256 cellar: :any_skip_relocation, big_sur:        "304a36764da647e5e058b853114949e797f8f57a2c529f2b869d6d6ae2da2305"
    sha256 cellar: :any_skip_relocation, catalina:       "c3075232b5bebdd119e6cee8734d1c5ea56bdbbbc756d166610e1eaf11696fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd1a454497ce215850e2d524d74630a114095da43135b6ddf2bcef8db2e1aee4"
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
