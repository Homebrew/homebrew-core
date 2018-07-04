class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/v0.1.0.tar.gz"
  sha256 "fa8a1e442fea42aab777c318a0c211e5cfc4572cafe22cc0ac8d1fd23a271e50"

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
