class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.4.tar.gz"
  sha256 "740e93454583eebaed10d22fe25c8ea20da72606cb053994c058240a4ee43563"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd0341d98c61e6f028e6ecb1de75171a65b8bf1cf3e6c3186c729c51d7d20fde" => :sierra
    sha256 "ee9bc759345edb1fc6e5ac6e740f1de16bfc2ba9c4b1b9d9f20db0c19d68819b" => :el_capitan
    sha256 "ff81022eb90fcf3105c744ac716e19af5ee046ff651e606cb2d85acaeb380c04" => :yosemite
    sha256 "480061ee5de5b28e6b3d8b59240a403321fc2196009fe8d546b49a780ad7daa2" => :mavericks
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
