class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.58.0",
      revision: "432209840aadae81ec9f128c48e92f3ebca1b37f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d36bd624a1979747a0933b44e9bce06edfed3a1844d7c9c5b68ea14e3f9e7b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68c166ba07a9262aecb239eab0232f61f3bc5e005b9e4ca64b1a9ef4da517759"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eac06dfbdcfa79f3ac196c9b75b0db388abbbecca89b94b341bc725859a26692"
    sha256 cellar: :any_skip_relocation, ventura:        "49a3d7c89529676d7bc5f2b20bba160164d3f59686aad95820854ba033c83fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "29bf3440bc113bf86ed030f98b6b8d05361a24e8967f9b931d7dabfd585b19d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "afbd2ab5340572e2e8a331eecb0851080c20a4c90bb0c2599ed4a673ce6a8159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0005c7e115949e8766d977b5083d00f55e5bb2a3194440eedfa2e8f014d87e28"
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
