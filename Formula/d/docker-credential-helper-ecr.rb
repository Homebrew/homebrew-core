class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c874cc88850330fd7a93452c7c654737fa37f06916153cf818e49088197a5e4c"
  license "Apache-2.0"
  head "https://github.com/awslabs/amazon-ecr-credential-helper.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08d041e92bae5951b08ae9481e3c6bcf4aec5583324e7393e9aa7538c693d08a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d041e92bae5951b08ae9481e3c6bcf4aec5583324e7393e9aa7538c693d08a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08d041e92bae5951b08ae9481e3c6bcf4aec5583324e7393e9aa7538c693d08a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e82694f2c5f37d9690cd1c2060d7cc94a5cee9d7bc88b93735dd225e4cd29336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86525ade6158507fbba5982051aff57d186bbcadf576c82ab73f3062cf22dd02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6a16b2fee9192ce8c0dcea3f97cb7709b5faee28cb34418d46f25396fbfb0e"
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
