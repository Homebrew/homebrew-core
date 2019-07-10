class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/1.15.0.tar.gz"
  sha256 "fb31ad0057083a9b4bac6f86cc543dbf13574497305820a36103bc573be06831"
  head "https://github.com/aws/amazon-ecs-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2200fa7e99a3ae207c356279ab06086af138a95990b7e544995b1c8ef78f4f89" => :mojave
    sha256 "f49ba7cb9b353cf8dffc6447571b3213dc3caa2fd0288269d7ab39b56d1cd856" => :high_sierra
    sha256 "573bcbf83df485348e132e1c6243b7f5b596ee5a3763eefd85d7fcc7335e25a2" => :sierra
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
