class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.22.0",
      revision: "011fa0577e1a1fa9723bc5933aa562e2fc03d365"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc47e1b10ecd1beedc3eebae4ea33483488980e8f2740cc1111d090044c242ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "791812adaec16e1c14b1a47d0dfa0967873f0a0d7fdfe6cdaca54961d2ca9fc1"
    sha256 cellar: :any_skip_relocation, catalina:      "0bfec476175bf9dbde3c460ad894e5e7bee5289508b38e3fd46df133fd52c70d"
    sha256 cellar: :any_skip_relocation, mojave:        "49685943fe6f9cc87468386e206d4eae41c7cd064021eac016827f58d4c32d8c"
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
