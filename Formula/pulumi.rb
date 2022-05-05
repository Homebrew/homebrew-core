class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.32.1",
      revision: "fb8070829f9965455f351acb9bb52f57492518c2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b04612f847e00d0c5ae52c80053028936ee5c5f2a19c6d9c50d9fc8766b5ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4771d8f96f6b15e4b5aed84c0b7c4d0fdc6712f8c59f478b973dfd3149b94f06"
    sha256 cellar: :any_skip_relocation, monterey:       "8c2d302507c1860fc93a812c1a7d79ebbc4e4fc88e86715e298c4fd6bd29b518"
    sha256 cellar: :any_skip_relocation, big_sur:        "8314e361ece3bba9e7429376d619995f42be3450586ed62b367a94f139ffe98a"
    sha256 cellar: :any_skip_relocation, catalina:       "37999cad25dee32e6db885042c2404d09a4df8d1066e3ae5889e619f665d0247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622785e91cd64510e39680dd3db941689d5454aec45963a7d7b1d33b40dcef71"
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
