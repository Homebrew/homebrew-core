class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.25.0",
      revision: "5db7c9e27783d22b9817197e0f38f5d4108a2b80"
  license "Apache-2.0"
  revision 1
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15cde2f8a3ea342af5ebc50f6c4508af766a084a7e72c0f0caa486d66875af03"
    sha256 cellar: :any_skip_relocation, big_sur:       "cca247febf86a1a685d96569b132ad211acd9753acd872e99d981873a9cc1273"
    sha256 cellar: :any_skip_relocation, catalina:      "58c7b17e7a0c892f9ef0a362c000181bb3347afbc6ae8f6c86fb11addccc6036"
    sha256 cellar: :any_skip_relocation, mojave:        "e892fd9732c6b2f2851cdb457abbbf6a53c9687892e987991564f3e1410784b4"
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
