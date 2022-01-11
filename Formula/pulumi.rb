class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.21.1",
      revision: "c89abc9bd628751d2b1afd2c0a4cdbcf759ae221"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cc2da311be231b1ce6c860d42383df9518d1ae376f8b1ccb1e8eff8f5ebbfe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "975091ff69dc889048fee7a35dd578202e1e42d756310812462636e2fd27535c"
    sha256 cellar: :any_skip_relocation, monterey:       "0be3bf2a31f0782598d9d86deeca7839d44fa815178c56d10be54bf064f7b0c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7579544a6516545ba3bb87431f772df953ff348f6f737eab8eb74336df15c62f"
    sha256 cellar: :any_skip_relocation, catalina:       "35f805c36527f00f0f4163020d53e05402f5f64c27f14279be9e555f630dc6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32eaf975f2ec6b75422962792408ed5bb5568611c2f01e685f0de6dc559ebcf2"
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
