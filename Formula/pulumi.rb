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
    sha256 "578dfc1aabae9b3f07a95d4b92145703d8a5ba159757603cebecc9b735449d2c" => :big_sur
    sha256 "7a3849fce8b6f4edcef2992d92f8abae8442623071e40f9b28a63d201409b37e" => :arm64_big_sur
    sha256 "771b773bc1566dbd7968f78fc36a01e4ae41049abf2087ccdbc4b35871ed1117" => :catalina
    sha256 "cc71aa435a8588f05d366402310091e1409e89b042fccbb00a5ee9d1f32d7f5d" => :mojave
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
