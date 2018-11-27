class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.12.0.tar.gz"
  sha256 "6eb2dc138b10ea6f205f1855a11c333405592ab4683dc1a044561299d7d597c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b349335130770bf2e4ac8f43ce24f8de51e87d723202fa32abd73ed789791d02" => :mojave
    sha256 "8c04d513e584d7b9da2a4e0202aff0fe58542c1edef46db6de4114766ba0ef0a" => :high_sierra
    sha256 "155877c73520c130c40055f753602ae14d689a7b1be8847b7ec76d3df991dc67" => :sierra
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
