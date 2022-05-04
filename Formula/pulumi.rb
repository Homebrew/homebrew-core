class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.32.0",
      revision: "9cc93ba96f9ecabe3ed1029bbce18d4c6db11798"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb049f23f6b79a91343246f54bfd22637ff7c9c9bc44e42524ef0b73d6f856d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "248f38fc2c171216b27a84a94fb80fcbde8933600134814137f2f5901ed5c8f0"
    sha256 cellar: :any_skip_relocation, monterey:       "404887dcf30aa6b58d8da623bbca6830f732a9868bc373d6f58f7051d735d57f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fcabf337e9eec0ab30ab2b8ed6b17643424637de0d588c3fc1209718e37b650"
    sha256 cellar: :any_skip_relocation, catalina:       "9507123eaf7968389867aafa78487166d1a69670c827bc143eb35eeb9c55a5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe2cd373dd15adf6c8eb41690b6bd82ccf3de54332d69afb017db4e4d6553d5"
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
