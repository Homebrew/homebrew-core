class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.2.1.tar.gz"
  sha256 "0ffcb6d0ee5efcaf28903ea91ff6a68bd23cdbd29bf9bc33327fd017ce742bd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eba3271f11fe1472a4fe8a448da6aa8b91896b6aec3101099c6fa7a5ad3ef0a" => :high_sierra
    sha256 "a1a21f617e5d013cee206ec03a79f9cdbe9acb230de4359ab2b4fae33bf3c2aa" => :sierra
    sha256 "1fc3642b9b937d9167833e3ed9010fb81d4f4fe20c8c6f0252e4365170e7278b" => :el_capitan
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
