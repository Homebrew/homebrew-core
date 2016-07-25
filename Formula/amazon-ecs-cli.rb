class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.1.tar.gz"
  sha256 "153428c1dde521ce0a07fc6107e9993461ff81715a414af3493dcadba492d5de"

  bottle do
    cellar :any_skip_relocation
    sha256 "82237093242ed0728ffa8c2096d828b63a0e72be87008dfe9d0fe79920a169d0" => :el_capitan
    sha256 "81f0ad9e797b547b12f4d8e79107af27a90a6f9feb90df75f3b2b69619f01afd" => :yosemite
    sha256 "d330c6e6f11665bb40ebe246446fae8a5f3d8404c6f7910f8022de06821a9d28" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/aws/amazon-ecs-cli").install buildpath.children
    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      system "make", "test"
      bin.install "bin/local/ecs-cli"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
