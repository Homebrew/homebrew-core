class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.5.0.tar.gz"
  sha256 "24ff978bdd7564c7cd837346e7c3427771648999d162de3adcb90127b2802123"

  bottle do
    cellar :any_skip_relocation
    sha256 "5976b94f04cae4c772e2a870337d88dcf69a7215be99994f3a81abe6e47a32ff" => :high_sierra
    sha256 "8634735a033b0793afd60fd5efa5ae1b4947578434c077f7b325123cf26be9e3" => :sierra
    sha256 "bbda6807f5da80343b593f94498f3869a96b5cd7b2ccb1a4d91016a1507bfd42" => :el_capitan
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
