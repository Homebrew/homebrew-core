class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.6.4.tar.gz"
  sha256 "882babdf5d15059de6c9e91c9518b2d43a3450f1f50e81ed58c3bcf3a0405d16"

  bottle do
    cellar :any_skip_relocation
    sha256 "600b22fefb3f3175471c5e5f4b4d7f7b046145c8cca44a202dd76d907b282a72" => :sierra
    sha256 "0fbd3bcebb08293580483154b8a1ec30f41fb898e05749ed39c05ef8fbf19651" => :el_capitan
    sha256 "071431b0cf5be88b4536d29877dd386f11cc72e1ff3cd6677e406c3f9cf7e5ec" => :yosemite
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
