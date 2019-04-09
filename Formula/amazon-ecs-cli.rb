class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.13.1.tar.gz"
  sha256 "8d1854f47c4973b1eaf029fc2ac4dc69f12f0792479f82e03d510ce84e2a5eab"

  bottle do
    cellar :any_skip_relocation
    sha256 "d577492bf396f65d28f07ec5f856e8c9852d42453f12f0dba1411c5bb8de156b" => :mojave
    sha256 "0ea96b320b7b422cd9189d74ef298ae1e4d1712a6d0d770461d56d381df667e2" => :high_sierra
    sha256 "f14598f96aa097792844e32b4fe0fef85da38f8be6ae1124d9ed9df5ae6ec3c9" => :sierra
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
