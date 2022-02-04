class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.24.1",
      revision: "0d977721778805179bc502dddbdfe848f8477d9f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64a241be4cc3491f8d7fe4ded4a948c65ff604407478a0455e671f9f0e740a46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c95a66336d51cfd1b75bfac449715aefcb0b24a348b1d4bb305470960f9e429"
    sha256 cellar: :any_skip_relocation, monterey:       "407efb30901f2946e1b6f54e5d8e56c2fdec06af49f7038b50fe9952c4d6ca27"
    sha256 cellar: :any_skip_relocation, big_sur:        "583236a8b665bda7f43771816050933632e08d202d70b41fc8726d82e3d8015f"
    sha256 cellar: :any_skip_relocation, catalina:       "b4ae27aeea47eb33815cd30efb96dd3aec0907736d1ac5ec3947c783608653b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f2a9e272ab458a305d3d7e7c8ababf803448aded777ae7c24a440a135ad338"
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
