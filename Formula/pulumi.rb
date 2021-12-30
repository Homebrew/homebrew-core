class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.21.0",
      revision: "60df12a2d213fb7a32007ff15aa7a838ba15b9b8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f8ba6c2a761cde98063954c4bd4d01fb546fde14219f7da9ade17a8b1e55d88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "007d12f6d07e6ba0873a19c8d003ae884098b93b8d697237d246ae664b91a8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "329bf31b18c8f9ca758f80922962c51e4183fb3f1cf97a970d08ee7fab8fe9a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "793a552d116b46675ffd5e144cbd83e6b28c5b23ed857eca340dd9f64dda5cea"
    sha256 cellar: :any_skip_relocation, catalina:       "3e90abb56ac60c8295abc79a59fbdaf43391ca1b74a2c6e378a9da380ec178a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0a17299ccbc60747b4df107d2c5a086774d5badb2c7ceb3f21346b0a133e5f1"
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
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
