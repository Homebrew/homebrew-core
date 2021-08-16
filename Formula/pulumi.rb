class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.10.1",
      revision: "7b28a0a0cfa0774f61bd19837fb02fff05db3553"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ce7e081d31153bc6ed8c329548582d0beda8df00397a2f350d22019cda4fd38"
    sha256 cellar: :any_skip_relocation, big_sur:       "7de6a89e9be601dfa168676643e95baa6c87c51509ccacd44660976bfe3e20cd"
    sha256 cellar: :any_skip_relocation, catalina:      "6a4af341a95865b8b1bfbffa1cb6f579b57a9fdba6fc51ac61dd83f30e060808"
    sha256 cellar: :any_skip_relocation, mojave:        "a207b2d7865e1b9fdc9cc594b8ee4aa6681b8fe40cda30fb6a0aa433ecd3e092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eabe260606b14e077cd724b13787f2cdb211b0b52c0b539640632e72f0c5b9b"
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
