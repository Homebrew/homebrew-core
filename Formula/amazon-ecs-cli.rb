class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v1.11.1.tar.gz"
  sha256 "df14915043aecec4c36106326b1fe6f6c50c801c5995b3172209f1b12fd36cc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f060f0536e40fd51977fec2bd99570d92a3eef80bada0f910f9d3cf5d803727" => :mojave
    sha256 "a22c2804714ed7668b7f9924932f3d6c8939eb21369b34edde3bdb66124d9b37" => :high_sierra
    sha256 "e64c517cb79cd87a95b0c791293210dc4c29462073a0d79725f967264c4f8325" => :sierra
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
