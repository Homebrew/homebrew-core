class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.6.5.tar.gz"
  sha256 "351af32b3127dc48ab3d4b025f50e9eb5bb1dd98ce072bfc3848813a41e7b2ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d21ad81b12d3087875de3acb6db52c5497bbb02fd65243f2355f2ab10d0b5ae" => :high_sierra
    sha256 "77d51d4c34c1cddd9cd228e4ed9953b40b2a36ba37f7fab741fbaeb775bfbead" => :sierra
    sha256 "d261582d235492c94eaa3b262b98cc3dfc43016d38580faf822453539aa29f79" => :el_capitan
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
