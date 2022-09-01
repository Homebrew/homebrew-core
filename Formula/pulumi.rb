class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.39.0",
      revision: "caa0dce448a794c8bc3e5964b6f312c1f5715354"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb161d53b1765e46aba63e23a436f237ca5b31931e18473a5551161afaff5f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b4933fda47f22cdbcccd056be8b30761d656921f719985224b9fdb055e9ee81"
    sha256 cellar: :any_skip_relocation, monterey:       "b5499acf354be42f06145a21fd5c708dc838adc6a500989dfb22009d765aafe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb12106e975aed9f345931594065393ddc8ff5ed6027e235a19b7ff53c6daa5a"
    sha256 cellar: :any_skip_relocation, catalina:       "38cfe5402812e3d0c91dea891c6784b5fe2341580be36efa468874cc3892ff13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8925224bddd4f24b71faec5bff7e3488eab02aaf06e898d59173e3561b8a3592"
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
