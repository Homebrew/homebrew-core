class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.40.2",
      revision: "e8cd83a2698e382910c82ac98a7ba13026ae32f8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "187d5917eb493db90204bd8b71bda5b311f368ab746d8a9f3d109d4d3672ea72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b67143ffde4521a9060c85e0bdf46684bf75f1aefed01d3a5e47de10bac6cf2b"
    sha256 cellar: :any_skip_relocation, monterey:       "6897f3b5a201545dea3c0d0a1ce47d0566c07e15486246d0643091cdf3898f3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "97ca1cf9b132ade6e109a6415b420b561aebf73203899df7f8c1397e4302bbd1"
    sha256 cellar: :any_skip_relocation, catalina:       "1ca7f10d788236e8866afa3d7a2e5b643eec0c47cd83c09b6947089923825771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f1b893737dfaad3b76968aa9fa4ff66d2729180e82f069fd91ba7fb8372077b"
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
