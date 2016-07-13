class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.4.1.tar.gz"
  sha256 "153428c1dde521ce0a07fc6107e9993461ff81715a414af3493dcadba492d5de"

  bottle do
    cellar :any_skip_relocation
    sha256 "f633bb5fd45ee80e075899c0f4b99643337f266fb1514d0351845c76d1d076fd" => :el_capitan
    sha256 "a527cfe0903d1f9546741c38b271a26a827e570a5e3113617500af334d3b24be" => :yosemite
    sha256 "343aaa12ee2231ab9b57828cb1a1ac6c9804c68b271309246d0d77dd71f903c8" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/aws/amazon-ecs-cli").install buildpath.children
    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      system "make", "test"
      bin.install "bin/local/ecs-cli"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
