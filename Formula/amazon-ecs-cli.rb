class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.17.0.tar.gz"
  sha256 "628bdedf141c98a8c0f0408061e96edcf7fa882a06435b65119ff2c326e7a507"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c62e3319637879d76bf2d9e5702349e64c10f5e1a7d31ac3528a4022952a6a31" => :mojave
    sha256 "8d02711af8d7ff1a3bcc33c2836e2c9664865e4313f8a6fcc1ac2d55b5cc9714" => :high_sierra
    sha256 "c2b8ac3320972e73fd07ebf9821f28b854141a6234bfd094ed1fe8a13991c51f" => :sierra
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
