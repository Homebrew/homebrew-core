class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.59.1",
      revision: "20ee7fc734c4fac7b62048e1eb0d67436b64ebbf"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b90525c61c5bd1a54189364e5e1e38dbbe7c41cac41736c6d17597700c52a6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efbb08a95f52a0c9bd1610dbe62741b2b4513b4bc9949c8b2dd9522c8a13f2c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4304b85d96b3dee87ebeb38c8e31879ddfb929d2e997ce36a5528f3487bf4895"
    sha256 cellar: :any_skip_relocation, ventura:        "77a1ae08038c4d40b99c6dc3c0d463c4c2153d9310000ed93cd25e349d2f9236"
    sha256 cellar: :any_skip_relocation, monterey:       "1c9fbea332461a9a2f94c49ccd86217e166ad53b5a0f7c54541f55a85927e8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4abc131470833879ac1ae87c693001b891f0d569f1a40b4a0fb45173bc6c848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b23d34c1a22ed80f6006f71b1ac3c3089bd3fd81e426cae8d68a5953fd9cec0"
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
