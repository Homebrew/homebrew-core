class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.11.0",
      revision: "01f52892191cfbaf9fcc233746e473bfa1129927"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "081da8123a70f15fbb47853e1aa05016e9e244a7c4dcd6c90ad6b711af6eef25"
    sha256 cellar: :any_skip_relocation, big_sur:       "097ec56afc602c2534e4434b7e5ed4a783977a3d0b046049783daba3759e6abd"
    sha256 cellar: :any_skip_relocation, catalina:      "c43e44317532fac910af046726f0762265c8f69c3335da821d1efa5093634e21"
    sha256 cellar: :any_skip_relocation, mojave:        "7f945464c38caae88f0176cb29098572d1f17eb72c2e09e866fddb2ab7a10dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "792ecb85eaea940f6a540062c94775366ebe3c4f77df4d6d33fe3bbd8cb11975"
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
