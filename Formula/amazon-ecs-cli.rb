class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.0.0.tar.gz"
  sha256 "2458da61cc7d27db166c65d4f356dcaf2ef1d2671194a452e9345d97ff73d8a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "2028e018e73eea7acfac3929f18e295eb4a47d2d48e7fed3bf730c156476382d" => :high_sierra
    sha256 "5320fa565a78f345a5b0af36a78e06b489f62ccad3e24cdb7b00506189edcc42" => :sierra
    sha256 "0d321ef715ede927834854448b692e37348318470b5dac5d1ec67cf5abf7ae68" => :el_capitan
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
