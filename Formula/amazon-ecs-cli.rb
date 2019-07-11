class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.15.1.tar.gz"
  sha256 "7d3ef27f76887eb1e2106335160306fff4b15a768a3a3375c0c34c1200496f7e"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99913aa0bb43466d7a73729b852efdb27bf132bf7738248fc9b8df74192047f1" => :mojave
    sha256 "4f72234956bd19a087e14be6924a511d25dcc7152c1073bde3d0b8455f7b6290" => :high_sierra
    sha256 "fa15884ce10a9626ab482d8906d87b75139abbeb087be98b1cdaeec2aedf97f5" => :sierra
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
