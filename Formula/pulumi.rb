class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.13.2",
      revision: "a182f103cf9f2a521fe746283283246d8f1bfca1"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb0d38d835157210d84ccac3c602ec05751baaa0b96d8e24aede1780966add99"
    sha256 cellar: :any_skip_relocation, big_sur:       "93d693ec5bd2f33267a02dce7229264069e8d05dd5f0ccb17701f634f5b3fd8c"
    sha256 cellar: :any_skip_relocation, catalina:      "23f0da8d53af51860ac37fff1b6d0c10cba58d05742904e853674ec615a62232"
    sha256 cellar: :any_skip_relocation, mojave:        "58a0265e303b96134f2bc12d504a3a5eb467cd81fca9bcb379bf74f2dc721b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a468da122b3b70af140ced0eda382dfb044d3d139be280da58cef8a6d40edc6"
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
