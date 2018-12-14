class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.12.1.tar.gz"
  sha256 "ee04b8442353a01d2ce2e5107f8e996b5c90d3a873aae89f33d0aebe1fc48adf"

  bottle do
    cellar :any_skip_relocation
    sha256 "4544f0ad6675d3bf7b1ec1c0f94c0f3e3728346a8ae4a2ed806b7c47b703c05e" => :mojave
    sha256 "86241125a9d774a945545140022d9259160edd6f34cb24f0b05af392d3c0052d" => :high_sierra
    sha256 "25eaba806f9d118cf1e5e1f0df4a4f63c605072c15597976467565f65b4c790d" => :sierra
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
