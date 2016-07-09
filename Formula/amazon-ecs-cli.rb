class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.0.tar.gz"
  sha256 "ab00546387057fa56fa0fd1130997ea9e1725d72351555e157beba0fe890fb92"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd6c046bf4546f862bf49f4a7933c6dee08287db13720c631a07abb3375447fe" => :el_capitan
    sha256 "fc9f2f0fca776360fcc019add9207d260f79ddea8078abca277e260b10b4a122" => :yosemite
    sha256 "01f76b8b250caee54ab421685a5412d36b60d0259f592b1afce1ecc7afde0427" => :mavericks
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
