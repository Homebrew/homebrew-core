class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.6.1.tar.gz"
  sha256 "f3317a725a557d6dc7a87bf954fc966dd8b4355acb03296e363b3ef58e3cc7b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c056f0c7903b8e320b26116ec5ae18da87840b5a4db3b60d8ac9a1dc60ff7f4c" => :sierra
    sha256 "d32a46135be5722632239080f29f7c2dee11e70194dc2cf9bb434de057799b6d" => :el_capitan
    sha256 "850a5df8b16c4b06e6fb1996802e901f030dcc311bdf31b9297130ca2bd9df6a" => :yosemite
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
