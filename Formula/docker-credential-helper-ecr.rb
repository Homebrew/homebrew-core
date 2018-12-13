class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper.git",
      :tag      => "v0.2.0",
      :revision => "b9fd5a88b82e749a5227a31409fea58f91bdd489"

  bottle do
    cellar :any_skip_relocation
    sha256 "b268019fbcaf85125b3905b4b6daf7b0d9879bbc2b80b62a3c12ad8d4ef14e36" => :mojave
    sha256 "ed67a3621f3b9428b2ddd35495333c71d9ed48e78025c9c048e605c6b75a152a" => :high_sierra
    sha256 "10e0717849f7905bebdaf5f08c99b2b8071341bddf1d5685e7de55c74c51dfbd" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/awslabs/amazon-ecr-credential-helper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "build"
      bin.install "bin/local/docker-credential-ecr-login"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match %r{^Usage: .*/docker-credential-ecr-login.*}, output
  end
end
