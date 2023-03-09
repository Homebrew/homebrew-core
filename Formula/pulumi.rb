class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.57.1",
      revision: "83361f5f5c9083541ab43425a9c22546b24a0964"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "562bc6f74dc14e0f8759da40681b1258ed8cabe3d1360384b693e39211a3e097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af630bf6876fbfb90ffdada9ce9947766f0df25e8de2df6ec4b96b2e3704d76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1624c46da0de2f4030b11aeff6c61eee3f80540c97a4231d2b114d86b66e90c5"
    sha256 cellar: :any_skip_relocation, ventura:        "032dd63675bacd1ef036f56ca0cc034f66372aebf5de778e7fb8d179095b15c7"
    sha256 cellar: :any_skip_relocation, monterey:       "6114a25b6cfbe168f7d572f62e5d29732c27aa7aa5c11266aaf14fa0991ce1da"
    sha256 cellar: :any_skip_relocation, big_sur:        "5742835cb31ec23b97dfa631c2ff662c1f14ab388494a9230d3c513a85cac550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b48458bf7cbc25ff1525a63b76478bda820e40fbdcb4385c540c8d88e6e44ec"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
