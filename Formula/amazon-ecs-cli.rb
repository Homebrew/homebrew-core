class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.6.0.tar.gz"
  sha256 "f1189cf6eab5bce0161aaf4280193790b429c507a87dc240786fb6d506a5f70f"

  bottle do
    cellar :any_skip_relocation
    sha256 "3290688ce1945553b6ccbc021a830840eeec1d540bc78e2617e7701180299c36" => :high_sierra
    sha256 "a86505088a84910375bb7332d6cfdf1b7f7fbaf24405b0f16e9891e59d6a11ba" => :sierra
    sha256 "3a53e9b30020275a6bc34d222a854d1c7b47dc52618bf1a6103877fc303e275c" => :el_capitan
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
