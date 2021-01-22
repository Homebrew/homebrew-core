class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.18.2",
      revision: "3931d410472d3348b369b71820298f69cb0cf4bd"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ea9bc752e81e73233dc82dd30e67a053656e727d04e115941eaea1ae56d0014" => :big_sur
    sha256 "b03f0c8e587539c6100b24aec9a4f45ca28ef3ddb6f8a3f4f3632de040ac00be" => :arm64_big_sur
    sha256 "61847a13a8ee519e96b2ac4113511e02474fdaa30d5dce9a2ecce3aa0fbe2006" => :catalina
    sha256 "0f0d59c8d7cba776da2f6e4f54c469eb75c7717a1e1f661b995944acf1934a0d" => :mojave
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
