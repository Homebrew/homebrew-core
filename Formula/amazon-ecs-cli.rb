class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.3.tar.gz"
  sha256 "b92c68f1e552ad4edf02089ed27e2e8675eb7316022f3466bc142cc83515bc24"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ee1950e23a56d69b9e7daf485705dc89af95507aa92cbdc708a0353a84a1d97" => :el_capitan
    sha256 "4f279ffd7972603e0da1c8860fc6a581c1e4da5967d68403ea9c07f50052bd0c" => :yosemite
    sha256 "a9c695c1f569b9d43a77f9e15833e1a7df25fa832d094b3a76e34b5ff1fcc48c" => :mavericks
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
