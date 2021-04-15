class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.25.1",
      revision: "c26d89f734c1e9e5f8d626b67106f04e69bf56f9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "760fd16d01d16462b9db8009f99b4c1fb2fe2feb5cfc9246a71a1d3fdd4179f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "03e15b92afe05ae9d1e851a1d344c4ac230ac5cdad252aa081a388fdada01706"
    sha256 cellar: :any_skip_relocation, catalina:      "c64735f17633bf8cd7d0c9394fde993601b63f5e9345e18a72594563b39ea2ee"
    sha256 cellar: :any_skip_relocation, mojave:        "4f696e5019afca0ca6c5cc10d2056bf8885ae546a050a3964d09c395ee872e5f"
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
