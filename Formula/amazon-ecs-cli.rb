class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.3.0.tar.gz"
  sha256 "d995b54b7a970880032e1c52d7d7c39672eacca575b5ca214d91c9230e31b57b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0a4772df6393a0788eabbb65e4e34c51ead2e3cda58e3a76d1100866d033c96" => :high_sierra
    sha256 "d2ba421659ea6d53fef61dee146c7ca7c8c835dccb323a8184938aabed05747a" => :sierra
    sha256 "e974f26497bb01f1d069c7a09ab69bdef239f87a3d969da01fda1180873d12dc" => :el_capitan
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
