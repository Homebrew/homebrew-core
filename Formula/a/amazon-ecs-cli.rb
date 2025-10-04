class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs/"
  url "https://github.com/aws/amazon-ecs-cli/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "27e93a5439090486a2f2f5a9b02cbbd1493e3c14affbbe2375ed57f8f903e677"
  license "Apache-2.0"
  head "https://github.com/aws/amazon-ecs-cli.git", branch: "mainline"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9a98803f22995cb9fd3ccfff0d9ac6bcb8de73df88e94c9bf60f16181ffab227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "946c2dea923a3f6ce1247becebbe353802a74bf44b5142d0ad0d5548e8fc1ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d701174d94a2bf504a8f73efbeae65ba21319e8ec2f8c686341db46bed1015f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef77e9ec799164485117cc7971285ef4cd0d9f7ce526eff3955c18270f215c0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "997efae6c4c5bd40f018cf944093c3842d52c8ba09e6bbc68715b697438a1f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfe17f71140b30b124679fee0a7b402f8f16a3d284ea357b315f2f9896f67beb"
    sha256 cellar: :any_skip_relocation, sonoma:         "07a9670e96753241bc2088cc23591db1da13ef3c190bdcfe0c077e2b871bfc7d"
    sha256 cellar: :any_skip_relocation, ventura:        "f020f685eb458c206f9dad7f6f2d6767bc088a5132655569bd5d652552cf211c"
    sha256 cellar: :any_skip_relocation, monterey:       "c052c78ca3a7a564bfb1544cf70d6cee45fb933ae0ce6f4c9abe987df2e194d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "66dcb9af8a67215a8a1f4fef00dbf0c16e836cc65985a86d113cb4f208dff50c"
    sha256 cellar: :any_skip_relocation, catalina:       "0bb03d95203b20aebc66ee008946951dfc66a991d6015f38d9158cda3dc36b8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5c02a7a6f0510165209dd1770595340906f5c0165084dd88801ef76916c61270"
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
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
