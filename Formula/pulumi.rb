class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.15.0",
      revision: "a6e02d6dd87c8122fb339feba3b0db3443748723"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f1774607c3009ea4d4cc649e745c04593dcd50608f432265e89686a237edcc8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e37ae37c8539388eec93ced30edfe0f4b935e95753d22a9b87ca96a32d363662"
    sha256 cellar: :any_skip_relocation, catalina:      "3e289ebf1dd7fafbd9853dcd9572f5bed709a0723195c05373f501083ceeb377"
    sha256 cellar: :any_skip_relocation, mojave:        "bc4f52f570b68a68c84233da1ee09ec01b74751c56b36c94875a50f3e179eed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "755adf238567532fe91fcd1808b08b279a5172759bfa96a340a92c80de89d3e5"
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
