require "language/go"

class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.3.0.tar.gz"
  sha256 "6f3ea5559a0104d59260618734c5992a85d48cc2702e7198d1a93b9e701af9ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "38f945f459a0df9e86ec2bc07b75bc54510531c2b720752f6db3a43179d00962" => :el_capitan
    sha256 "76b717844b82da1f22709fc50909361a67b3e7d0cd85ce17b39d0c07745ad28f" => :yosemite
    sha256 "fa22ea1ca4f9a725efe3ce46ff97792d36797ee16cc1a439bbbd13d594ec511a" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    clipath = buildpath/"src/github.com/aws/amazon-ecs-cli"
    clipath.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    ENV.append_path "PATH", buildpath/"bin"

    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      bin.install "bin/local/ecs-cli"
    end
  end

  test do
    output = shell_output(bin/"ecs-cli --version")
    assert_match "ecs-cli version #{version} (*UNKNOWN)", output
  end
end
