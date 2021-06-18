class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.5.1",
      revision: "d6f11cf650102dd674720d7d0a5e161f8e6ec2a9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7b490a4c73eac26397eaaad977dd907974055dbf8ef5030e9f3a983a3a1a17d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9578bcdcd579cce610f014346664bdb1fe88af597308683d1f3dfa7b03cf103d"
    sha256 cellar: :any_skip_relocation, catalina:      "95ebae6a3fa64cd8c23f8ff879feecf00b89186240c077c8ac1604ba1635ea01"
    sha256 cellar: :any_skip_relocation, mojave:        "a75431ef0600dd628bd6a9c8c21bbb1b288f6b144fea32806ffa9df01431e115"
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
