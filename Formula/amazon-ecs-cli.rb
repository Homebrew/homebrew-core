class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/1.14.0.tar.gz"
  sha256 "fe1df63675722aa26d9182447563297a7de21d1a2e867330c3ee186ce8c5754d"

  bottle do
    cellar :any_skip_relocation
    sha256 "01f155e4dc725378076e708c8558b42c5d4fd6d9a583b35ebe6490251997b869" => :mojave
    sha256 "db37daa5a6d7b1599e26f0e09a7a00f98b0b813505853adc51d49fe651ab41f7" => :high_sierra
    sha256 "7fa785c1f5f646c510835a3b220ecaae02c86c016f3544c7810be738a6e782fb" => :sierra
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
