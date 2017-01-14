class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.6.tar.gz"
  sha256 "d61c8f09a2a31d160b1676f09ab7360cca9fdc00bc28c24cebbb5a05d5f38319"

  bottle do
    sha256 "98bd2a5e34576e4fd6ea4a46946f18175217855e0271225801debe9139688c5b" => :sierra
    sha256 "1b25bafe5385f0f4682284bb7bb2c2a9ef906ce5f8cbdc0f6eacef50c24a842d" => :el_capitan
    sha256 "33d5d55673c60456a874ba1b08638d0202ce8c897933ca08690bf5d80a538476" => :yosemite
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
