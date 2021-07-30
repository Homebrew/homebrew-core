class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.9.1",
      revision: "994f60b319afdcdac3d81e940de7e875244b3cd1"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0b7a43a55042274a378682ca4c7e6103c30b7cbce099e1dc0e8fbb4c54fb16ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "2aa4bbbfe16233d4afdd796a35a39044b083fd977dafd318dabbcf896458feca"
    sha256 cellar: :any_skip_relocation, catalina:      "3c0ff4addbdc4ed4eb83ab511f17ef1969acc46238d9d79df8baecf860fa6cad"
    sha256 cellar: :any_skip_relocation, mojave:        "0bc604db90e56ab92171d0b7f377d21d6130c2aef6694e180fb0bda0a768433d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ac67c01f607ec647f5821d22966b695a36c5e3bee2b8b535acdec9e8207543"
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
