class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.20.0",
      revision: "095d7470a2f5a51a274aa7ba6a04d78678f30552"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8156517e0bde1eb5242901a3ecab9ed2516197963fe9332d2bbf0ca17ce90685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "160b3fd635d41fee85ddc6fee5da3cbca7460da7370884df7d4e19c46ad657ce"
    sha256 cellar: :any_skip_relocation, monterey:       "5cbf3fa3d84b021370845367ff0eab0d4af06e1a764f0b122a6de7060a5fd55b"
    sha256 cellar: :any_skip_relocation, big_sur:        "60ffa49c99d268b88b86e9dc74249e03aa944f48d005231106225a39c7c2c72d"
    sha256 cellar: :any_skip_relocation, catalina:       "5af27869b7cdce40abda6be547828596cf74ec228b907e7b680509fb5d1b3cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce287ba7f2c9b19ece1d8c823ad58196a936373462d9bfeb4552cf1f39e5ab0"
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
