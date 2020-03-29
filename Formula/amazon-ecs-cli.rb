class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.18.1.tar.gz"
  sha256 "d9b13f07d7385a85e6259333beaa799978113791a42d97d2421fda12e066b689"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e045052cdefc4592a76ba780461ede0f2fb8822379d944b35f0187155abc1d0b" => :catalina
    sha256 "915a07808c7879efb88e4a15aa0e1e87d0ac7f6b0d5f79e12bd9363482cf832a" => :mojave
    sha256 "03896b17cb673669db3096a238643029ad14e90b468004952198ee2c802a78ff" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
