class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.13.0.tar.gz"
  sha256 "bbbcb3aff971f71a5b565035fdbb6c09145b7ffc93015aa77a8f552d65776d89"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7495d64ace573aaf350e0ba7246dc663fe664582244b64872c15372a766250a" => :mojave
    sha256 "ba77b2c302a9a8c67316c5fd540d496aea5ea0a3eb31d82090d0dc7cb05d2079" => :high_sierra
    sha256 "fbe00c2733e0c513d43d8000b7dfaa2ddaf981515e6c608d162013259423b9bc" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/aws/amazon-ecs-cli").install buildpath.children
    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      bin.install "bin/local/ecs-cli"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
