class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.1.0.tar.gz"
  sha256 "8c1c72b74625fb66c3cefe252a66e7cd370507b6b94ebb5fe9ccb0e4440e2722"

  bottle do
    cellar :any_skip_relocation
    sha256 "6abe62880dcb9a6488c053b6bfac38a782e46602f7da91cab529ec5d7952368f" => :high_sierra
    sha256 "af1ac5b5e4307c79d3086ec05b0f0035867860cb7533c3f03b9eb75a1caf5aa4" => :sierra
    sha256 "954146123450f27fc916b28a64c52c66aff7473e63bba4dafc6f2e10f3019016" => :el_capitan
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
