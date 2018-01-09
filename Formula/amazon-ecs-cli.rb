class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.2.1.tar.gz"
  sha256 "0ffcb6d0ee5efcaf28903ea91ff6a68bd23cdbd29bf9bc33327fd017ce742bd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3a5f24bbde0b8accdbcc0cd1e552f3cdde149b96a8827bc8cda0dcb4bb3fefa" => :high_sierra
    sha256 "90440e6712b69d0324b3d4e31da9313774e2bfa349d189a8357b053519541d7a" => :sierra
    sha256 "b95170c291c07aff68ea4b0c091487fa557bddd25bd317b06ebad6b349f37310" => :el_capitan
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
