class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.21.0.tar.gz"
  sha256 "27e93a5439090486a2f2f5a9b02cbbd1493e3c14affbbe2375ed57f8f903e677"
  license "Apache-2.0"
  head "https://github.com/aws/amazon-ecs-cli.git", branch: "mainline"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "997efae6c4c5bd40f018cf944093c3842d52c8ba09e6bbc68715b697438a1f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfe17f71140b30b124679fee0a7b402f8f16a3d284ea357b315f2f9896f67beb"
    sha256 cellar: :any_skip_relocation, monterey:       "c052c78ca3a7a564bfb1544cf70d6cee45fb933ae0ce6f4c9abe987df2e194d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "66dcb9af8a67215a8a1f4fef00dbf0c16e836cc65985a86d113cb4f208dff50c"
    sha256 cellar: :any_skip_relocation, catalina:       "0bb03d95203b20aebc66ee008946951dfc66a991d6015f38d9158cda3dc36b8c"
    sha256 cellar: :any_skip_relocation, mojave:         "ac8ff57a4b7de517c767f53626f19d134732c9b3a9d68143cac9d4440f01cc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bfbca5701b37d685a0f5da1a135e736e4a594079e2368262c498396f4446261"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
