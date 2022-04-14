class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.29.1",
      revision: "0931a17acee5702a293cf4774da3cd095b677f04"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6877fddeb41f27cc6b2e377b681d5d3643cfcad8454ab99e37d1796ccee046a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9fe1322156a3e7710f724abbc9388089453da830c7b82b7388b4a9583615fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "81eea3023dccb102b27065a5177a9e4d73f65aa0ef4b4e5207c07fbb3fa7c6ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b11c63f4c33f3603de4d355a45ce453c661d46ae08ecca5964b5b7a5cf3a608"
    sha256 cellar: :any_skip_relocation, catalina:       "677f8091a1cd78e20b48d7a2961b61d6a1ea584a8a1640a4fa18ea2412eddcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a1fc7f7790ee0df60b5131b3b777204298ccaaa1a08466ed4d18ff4c5dc71c"
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
