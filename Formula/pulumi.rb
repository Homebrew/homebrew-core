class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.34.0",
      revision: "2baf8da48532f1020e7ff81f0cfa3601bc863634"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75d8960f9ae01358152d03eb587db1b78b580c109829be6944bbf8e703ab736d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa378fc35af0d441d647de718671f31339905df53102958e356d4adcb2c47e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6d9aa1bb84b239d1ef03bd83a93930b589a4293bdc5f05bb70085798dddab8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c02da10cda4cfde4432f6d7860ae2a364f688000a13a6b5036f9d8ae54cb338c"
    sha256 cellar: :any_skip_relocation, catalina:       "9a338b36de8c9b1afce4347ede1b1179349dbea378ad5bdf9046531d9e17608e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aae5726978c47a6f2eb2a3e648674c50e67f34a12fea888bf5c776eed291b708"
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
