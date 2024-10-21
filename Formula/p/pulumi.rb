class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.137.0",
      revision: "0d458a47df69aeabefb79632884c9411eb611a36"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c9cd2a331474c35078c838036c7d76d9fc42fc8c2111563ce4dbf982d69d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "876346949396dc7b989e99da88355d6569d097c6c5e903be3941e41d06c07a5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1915c225c1bbd1f0ec83fbb1a71f797ba62d27f648f87a0223bdf47f9790593a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae3f58dbc494b9fdb09fac4171834cb4fd332793723d8235eae316c3361f5608"
    sha256 cellar: :any_skip_relocation, ventura:       "7a7f42cf33bcbc62e5dafe5b3ec4fc5f11aad95f58405fa9dd7b27782fb9d6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01120f0cc7eefd6713f68d0cdcd679186cac553606f580eedd85792b3d973eab"
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
    system bin/"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
