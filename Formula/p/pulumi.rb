class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.87.0",
      revision: "bd6e2c3e7af3acfead2339435a77f6dc2744c8e5"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e10e991e35a4b8fbd6cff90418aabb8529e39cf6b51f5a4cd10b3e22de0ebccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70e4f9a7993f716a004cdfe44759e00099c9255624390fc1af96f4f1b5f3215c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82d48a38ec308dad89724ef5589a1e7468624837a7fe0aa80aac7553cdbf6df9"
    sha256 cellar: :any_skip_relocation, sonoma:         "17849fb1fe56899e323443c38070968f8015db01f6bc46a6d3de8355788e33d2"
    sha256 cellar: :any_skip_relocation, ventura:        "31e9021fc1d0014bc62d5e4d3ef384cb13a250c75320ebd4883161e0f20d3025"
    sha256 cellar: :any_skip_relocation, monterey:       "770c157fceed7046c90f6c1bbf95b1f4b1883b2c3cbc6e8ab5b72a0f1b45f60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "213efcb2b2d1bfa07ab567967ef87abb395e37ad1c22f19359372c5f57e4a0e7"
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
