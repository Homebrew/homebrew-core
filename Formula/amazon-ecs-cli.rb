class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.7.0.tar.gz"
  sha256 "b25d3defae2977aa696532b0e68afebd1e587f90eb4c39c64883a4c15906e19b"

  bottle do
    cellar :any_skip_relocation
    sha256 "34322074839213f1ab405554d2a8d1ec1506add42be15590aeec1d89c6ccd404" => :high_sierra
    sha256 "647a1f4c789baca9ac4e2a9f5705e339c2dd6ed8b203044b50ce5b45aa6ac907" => :sierra
    sha256 "55e4053ffaff10ed8958e87547c4bbdd6f7a5fbbc4a43409f7dcf6373490a6ba" => :el_capitan
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
