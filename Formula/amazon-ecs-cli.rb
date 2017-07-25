class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.6.2.tar.gz"
  sha256 "d19fd43014ae27947543965ed5c5a1c2c724b6bcc0aee7f873d6bdb18e9fe8ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcd70201337eac96b1ae4c4cb7ef2c7d300594e3f79762133a1d3626214726d8" => :sierra
    sha256 "26015936408dece17463b2b0618ade15e5c58d030be97f207e85a73c8265e86c" => :el_capitan
    sha256 "a0c32e166873c2fa37f53c1030aec80fc1922503a201c4a86ae662902e82a675" => :yosemite
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
