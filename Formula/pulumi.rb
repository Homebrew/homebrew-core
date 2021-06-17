class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.5.1",
      revision: "d6f11cf650102dd674720d7d0a5e161f8e6ec2a9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e92c3d6a4680d5ca49850f4fdcc9d8e87e612394f248d4fe510c0f854a5676f"
    sha256 cellar: :any_skip_relocation, big_sur:       "8137b4cd5c4e1717bf67da82e67e1ebd74c900eeb9a0390873bb236ec3007ba4"
    sha256 cellar: :any_skip_relocation, catalina:      "a7d985346d66c8fda1f52bdf837150927a330bfc4de25d7b42a01762516c2254"
    sha256 cellar: :any_skip_relocation, mojave:        "661847f647be268ea9b051ee2997618bf3aaa3a12840dc2ed87a032c96af325d"
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
