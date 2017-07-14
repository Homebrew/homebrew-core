class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.6.1.tar.gz"
  sha256 "f3317a725a557d6dc7a87bf954fc966dd8b4355acb03296e363b3ef58e3cc7b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f6d2c3ad8a6c7a8365e8bbce9930b14310511d479d0c57532ea8f69945d8b7c" => :sierra
    sha256 "85c924e63cfeb26db2e11b1e64cb59b455e7a7498f3dcd7cd4badd6885737733" => :el_capitan
    sha256 "190d2488d6298d43559369f67488d2dcd7ceb80d4a46f9730edd6d421220e922" => :yosemite
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
