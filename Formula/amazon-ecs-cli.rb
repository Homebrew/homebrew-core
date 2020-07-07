class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.20.0.tar.gz"
  sha256 "67a9db1d32e5cf42cf6e8ab5b746e23af60120fdd0d0fe38c9fa3b214cd7fcd1"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d86f8ab877483a5f9612c7a668b5b81e5d2c758c0fb713cc84fb0371e3c005d" => :catalina
    sha256 "791f175e28303422664e373313952fa2d8c1074c66435f9b70201d77f90567e9" => :mojave
    sha256 "f15432e9a164b3602b4722c81d03d0d70116d947859b6d113d5b973d0e3d32bb" => :high_sierra
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
