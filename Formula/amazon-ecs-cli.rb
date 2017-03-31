class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.5.0.tar.gz"
  sha256 "b6a4d8950c467964e5d0e625fdc48479a78851336cff50ab8f325e40a79bcba9"

  bottle do
    cellar :any_skip_relocation
    sha256 "89a62f4c1fca0cc706b24a8b57bb2cd029efbd0573c499028468b208be6dd4e0" => :sierra
    sha256 "8d88606e7d53ced72b21b06e817d672ceca599ffa9b1962cc9c1ee609e3807ee" => :el_capitan
    sha256 "3f9804bb7222efcf36988f4c96f6a6b9c066ade34fa70b8ab4668f704e3e1d88" => :yosemite
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
