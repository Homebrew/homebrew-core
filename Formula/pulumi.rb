class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.25.0",
      revision: "5db7c9e27783d22b9817197e0f38f5d4108a2b80"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a0fdcf7e58f2a2b3fb6af279af49f12097a029a29b4e2ff41879851c6126bea"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f0b89c95b57be7459bd601743138866a57ba7a85f1af1fedafe2536fcb5974f"
    sha256 cellar: :any_skip_relocation, catalina:      "2a65f4aa03db6a34b6f387ecc6c2709b828bb9a016c5c77cce92cc12ab892171"
    sha256 cellar: :any_skip_relocation, mojave:        "05ac3311c9dbe41c35688049522657170ba593531300fbe99880a5e3ea44f0d6"
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
