class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.18.1.tar.gz"
  sha256 "d9b13f07d7385a85e6259333beaa799978113791a42d97d2421fda12e066b689"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6933d2da6d4c7e83e0f42827b1567a52a992be14a0da20ca99df064b5c82c006" => :catalina
    sha256 "0e697cd142e5e8ba85b69048714f4f3e1e85832dc75122b54287c09b2a5cae4c" => :mojave
    sha256 "60c8f6eb21498f312f8cc76037f9ebb854dc9ef1853a9730038be84401e6c0bc" => :high_sierra
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
