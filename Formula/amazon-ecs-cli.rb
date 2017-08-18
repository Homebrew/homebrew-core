class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.6.3.tar.gz"
  sha256 "ad86f11c13cee7faad63c7c215910778fe86d37e95cc23c9c40bf928153776d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "930fdd096a22f06e27b785bcc5ced7bf8a757625975442538677f05a004e98b6" => :sierra
    sha256 "3b07fe0b0e54fd52dd10351e5cb7931ca97d56b18227df70106d409487a879b3" => :el_capitan
    sha256 "5ce3f061abef3235bd1606562ddd6028a5a52c3215a76023b22e8f2057f47191" => :yosemite
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
