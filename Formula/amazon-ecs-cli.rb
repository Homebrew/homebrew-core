class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.3.tar.gz"
  sha256 "b92c68f1e552ad4edf02089ed27e2e8675eb7316022f3466bc142cc83515bc24"

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
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
