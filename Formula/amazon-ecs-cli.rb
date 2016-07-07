class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.3.1.tar.gz"
  sha256 "45a5fcd9bfd4b32c3f9b4d37bbcca4230df97a4a4dd2f532e5709511a43483a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "38f945f459a0df9e86ec2bc07b75bc54510531c2b720752f6db3a43179d00962" => :el_capitan
    sha256 "76b717844b82da1f22709fc50909361a67b3e7d0cd85ce17b39d0c07745ad28f" => :yosemite
    sha256 "fa22ea1ca4f9a725efe3ce46ff97792d36797ee16cc1a439bbbd13d594ec511a" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/aws/amazon-ecs-cli").install buildpath.children
    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      system "make", "test"
      bin.install "bin/local/ecs-cli"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
