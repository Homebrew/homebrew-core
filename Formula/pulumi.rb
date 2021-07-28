class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.9.0",
      revision: "0215a4fb5111013c148f44fef96c9015d0f854ff"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfb41f88d896d2d047f2e352c8633d186220f33a271f834d5edaf5c99c3ae564"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef8ef3f0a223a92deeecf525e382223a75f14d7066100c499b55279736fe7052"
    sha256 cellar: :any_skip_relocation, catalina:      "cb2014662f60907237c1f1a16249ca348101649bc26ba77326f05ea35afcb5fe"
    sha256 cellar: :any_skip_relocation, mojave:        "0a7896453ffcdbb38ccec028a73a8e714aa1bfab8d4d76e6414b9a6eb1bbb712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed960272a76e75476cb72c117d091b6aca4b86b0e29102d3400d1a988d12e894"
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
