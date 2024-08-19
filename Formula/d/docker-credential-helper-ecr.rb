class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7014f4c972ef360b7204d376bbd771aeebb8f1e9281948688de1bcebb0d0b0a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f873d6f0c3a04233146794507346b99f55abfd85a130ec35bcf9a8d29dd82b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f873d6f0c3a04233146794507346b99f55abfd85a130ec35bcf9a8d29dd82b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f873d6f0c3a04233146794507346b99f55abfd85a130ec35bcf9a8d29dd82b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c46a758bda76377f33b87d2f612dbda72b990aeee931429aee3d7b18650c27e4"
    sha256 cellar: :any_skip_relocation, ventura:        "c46a758bda76377f33b87d2f612dbda72b990aeee931429aee3d7b18650c27e4"
    sha256 cellar: :any_skip_relocation, monterey:       "c46a758bda76377f33b87d2f612dbda72b990aeee931429aee3d7b18650c27e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4418572e63b5dfae324fd48ebf7fbc6d1cc5add18698b88cc6ae95579c0e44"
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
