class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.28.0",
      revision: "9f89feb16dfd437025a853c92e60854d638ef405"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38df3a6d10247e8c9f607340ddf50da9be1bae8d3a63d62a68c385d265463d86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2327edc1c5fbf1c703cc69025cfe0182b93581575869249e18c3a49d9eeab05"
    sha256 cellar: :any_skip_relocation, monterey:       "deb47c04be3c05b5da048c7c4b5758d95214b169fc10cfe3689dec92f59cb416"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d789cfcddca9e32df4faf4a71465a64142cd5ae4c6028c340d957bde3b31191"
    sha256 cellar: :any_skip_relocation, catalina:       "a4250ac4d83d363a34096b70462e11549ff9c54f91e41c274224edc60cb0ceda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9c9fde8d63e34790c7853215d2b617a54a1b3995f388322b084cfa4979d22a"
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
