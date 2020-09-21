class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.10.2",
      revision: "971a8bbacf855aaa25b63729a57037108e382fdb"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8efe347eb45bb7b3c732b8cb24e22996e9637f083fad8d8200710289e523456" => :catalina
    sha256 "c04c7e6820f12d3e5298038aa6e9032fed95e7b6a8fcdef296700c267712d697" => :mojave
    sha256 "9eb624a147a8c286d3d449df051584ea38954527105cdc7c2cdb3f41b6d501b5" => :high_sierra
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
