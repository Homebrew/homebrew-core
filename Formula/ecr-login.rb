class EcrLogin < Formula
  desc "Amazon ECR Docker Credential Helper"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/v0.1.0.tar.gz"
  sha256 "fa8a1e442fea42aab777c318a0c211e5cfc4572cafe22cc0ac8d1fd23a271e50"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/awslabs/amazon-ecr-credential-helper").install buildpath.children
    cd "src/github.com/awslabs/amazon-ecr-credential-helper" do
      system "make"
      bin.install "bin/local/docker-credential-ecr-login"
    end
  end

  test do
    # For some reason Amazon decided to tag this as "0.1.0" but the `version` command returns "0.6.0"
    assert_match "0.6.0", shell_output("#{bin}/docker-credential-ecr-login version")
  end
end
