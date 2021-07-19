class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.7.1",
      revision: "4e4fe65b365c2016174544ad312d09ca14fbc4b0"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2dd0ecece0b9839b269fc82669d728cb07c11f66bb9559989754e2d52e040d18"
    sha256 cellar: :any_skip_relocation, big_sur:       "f34433834220d5dd4693c974db9dfba773ef61275dd8dfb4fbde667331a6f4a0"
    sha256 cellar: :any_skip_relocation, catalina:      "78b5b3a58367d850959afdf92b826183396dc691d6827fdca81a2991bcd1fbe3"
    sha256 cellar: :any_skip_relocation, mojave:        "f59ce8f44cae5c1c37ac73e8d9318c3c00238e2f71b5d647092a37e5cc33b2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9785ee26360bf5404e7a8eeb08066e5df13919d963aaca6cbd2989eef52e905"
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
