class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for ECR (Amazon EC2 Container Registry)"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/e63ef99.tar.gz"
  sha256 "35f4cd78df27256f705858c5e33a6fd02882ae2ac50e60348c1ab00e9eb1cc23"
  head "https://github.com/awslabs/amazon-ecr-credential-helper.git"

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
    run_output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match %r{^Usage: .*/docker-credential-ecr-login.*}, run_output
  end
end
