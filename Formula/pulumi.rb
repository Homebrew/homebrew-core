class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.64.0",
      revision: "c3d141e5abf8dc3be28152abd770e04c238f32b9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3bc09db424975af616412ed5852367708ad813a6f06dc3eede08224e8160c50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9ac3782be1b5b8a5d5c6cd6977a5edf121365c3732a7aec67ff5af14fdf9a2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d3ed9cbdaa862af98e19af824fea9167f44418f91471e5b3b7e811b51291510"
    sha256 cellar: :any_skip_relocation, ventura:        "6744c34547f600239b06e36d7c1911f3e352792b57607d9be82948db5677194f"
    sha256 cellar: :any_skip_relocation, monterey:       "3c6222c41ca1997328cefee545083011368c30885a4b5bd862d7bce67cd5e6fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d152786c01844aa5d612450ee6e94287f64188b4c359447fecc0795c237b360e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d620e674e07482716e69acf3f38bb9b86370734b3219b47dd8eb32fc81a5b4"
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
