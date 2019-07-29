class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.15.1.tar.gz"
  sha256 "7d3ef27f76887eb1e2106335160306fff4b15a768a3a3375c0c34c1200496f7e"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "325693d718afe77f33c64489e00db30db8b46053825bda3b997ef7a2c4519746" => :mojave
    sha256 "5821b8c680510a04d7839762b7aa5277328659b7c2e4d37c8674a059c94f4130" => :high_sierra
    sha256 "49cdf722fd4d5c07f0cb415ca1c2f3d4df134b4d8d237188e657cd72400a9b1c" => :sierra
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
