class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.8.0",
      revision: "8afccf60ab182984834e7c53458efffc92ba7628"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f61710b005816fa9ebae1aca8e8db82886a5a81b778c8da7fa34350d4fb125f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "aeae7329dca4a0a458116abf1df655bd3b1648eac78b69625d4293ae1d028f90"
    sha256 cellar: :any_skip_relocation, catalina:      "8313d4009a9d6769e54fefe19ffea0bf578f8b9451bd3b1651b21f10447ffbee"
    sha256 cellar: :any_skip_relocation, mojave:        "d457deedf3d9a4bd595a15f8b3c9c6381ac3ce2d359c9641008eb12536eea25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90beb0c4a8f3612028d6126df9724d959d052324028f59a1d119caad9f2335aa"
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
