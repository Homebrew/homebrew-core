class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.4.1.tar.gz"
  sha256 "412cf8556f3a32a34187e61cb8c9bb45d7bf3f578f0c71dae7d1f892cf669be2"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc5bc4ce00fd5dcdc0f6ce8f753d4ece2173770b246c50cbcc58af00aaabbfe5" => :high_sierra
    sha256 "15dfd623fddb979c37b627d16e60cba8fd272c2ec8a5220a5ced7118ac0f126a" => :sierra
    sha256 "6bd96e81995ae69b973ebbe0fb5425bcaf1f0ae246fb92634da8a8cbf5b2ba07" => :el_capitan
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
