class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.2.tar.gz"
  sha256 "51d5dd27a28df46af00d1de586f8237ffa0dec0b6314bd18ff0c6ed09ffe3a54"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a4db20b71b48fc07aeaaddc0f74d72165c39935c6da9157fc801ae45ce9f352" => :el_capitan
    sha256 "b17399338df1528699ffb438f0d6f9ae705ed2704e78f99d157bd0220489e054" => :yosemite
    sha256 "207cc2c960bce4a55b9c40c604b6c1a45ab5d41127c6d2cf640aded584994c7a" => :mavericks
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
