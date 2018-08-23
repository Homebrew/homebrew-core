class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.7.0.tar.gz"
  sha256 "b25d3defae2977aa696532b0e68afebd1e587f90eb4c39c64883a4c15906e19b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a4783469233b2a9535b98b1b351f151deecdfe2d0bc30f8abb3002a73bc7145" => :mojave
    sha256 "c84a85efdba3e5b6205dd13cf62c1c7c0a56ad9a6277c6009e52688d3c09c292" => :high_sierra
    sha256 "658f4033ebda28ac671895dea8c132f62a96fe6dd4dd91de10b394b9dff8e245" => :sierra
    sha256 "6f9d3c50e8fa4b59720ec701fd83831600526787c1e908bb9dc269f646907c58" => :el_capitan
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
