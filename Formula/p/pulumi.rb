class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.80.0",
      revision: "d02306824582111bfc8b634fdc22a359b8e35007"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e01d826717ea4ac71557b740bf7dbf4d40cf95bcfd186b08120b47946923b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d79e8017f23460a8af6a88f4ce6888b94b8b444f63e0aea9d2f7e0a38c33b3ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7374427982fce36c67c224565d6b3b3f5cd8a87815d233477e907f4fb8a89e3"
    sha256 cellar: :any_skip_relocation, ventura:        "22eb0e1cd052bc29be4fad578787f671974ca136f4424ca3507c8efa5092f270"
    sha256 cellar: :any_skip_relocation, monterey:       "28224c9b425f282324543d563a3638ff9c2cfd9f7f94df2db02d813a1cf71810"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cd9d8c147a65e73cf324ea05c1f132efaf581330ce332ea0d1709ff6402349f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae61bdb0720de51de703e8708b0ac9c674ebd5ec41efe917544764a34b4bc48"
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
