class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.17.0.tar.gz"
  sha256 "628bdedf141c98a8c0f0408061e96edcf7fa882a06435b65119ff2c326e7a507"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a27aaa46212ab46f828f6cfcba3063fbd4f047b5dbc4ce7dfd65178d467fe486" => :catalina
    sha256 "be91b34b7aa244f51e4688794bb17bc8382bb2451038cb48ad200a37a810d0bc" => :mojave
    sha256 "d582102880102bbdcca6a4ed8f168203e6383af7bacd808bce5d77a59b28a3e6" => :high_sierra
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
