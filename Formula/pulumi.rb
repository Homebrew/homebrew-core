class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.40.0",
      revision: "1037d9afcceb158006ee6ce0f7072682b6f9b7e6"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c990fe5e0faa367ddf8b9bf7f511c0991b434b460559ac7b0c477a0195b874b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1fb8c8104126db9b90b4badf58dacae019ae55af9368bcbc1daff34621d7485"
    sha256 cellar: :any_skip_relocation, monterey:       "0096399fc655a8a1c2c8c95f023853a8a2a0a3a57f9947e10c001bb939d7f42f"
    sha256 cellar: :any_skip_relocation, big_sur:        "feae2e1d6868d1d5d185971ed5f24f3c494febdf5efc7edfcacb1b179d594077"
    sha256 cellar: :any_skip_relocation, catalina:       "e701df90c45fe665975e3a2d53e030c205a753391d53e167275ee502243e5130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7af002b65ead8734647010ac53a07b3a476569124a514311b38c4a38c7401d2"
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
