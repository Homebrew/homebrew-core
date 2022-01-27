class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.23.0",
      revision: "e0b67987fedaa6b26ce2f11ee264d62ce1372516"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d6c51727ccfaf9bee41efcf016a1a92792927c9b1bcd7fc7465c7c15064058d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c34c436217801da29a198da732d804f971df91adf2c1ade5f649d01ca04e2135"
    sha256 cellar: :any_skip_relocation, monterey:       "354d72e7611ed5ed0bae080240420d422c1e20b4d4f700c536e13480718cb410"
    sha256 cellar: :any_skip_relocation, big_sur:        "90dc0f9da1b9baf343e36c219fa3b796a763706d50d547c6b9c79e55da523c21"
    sha256 cellar: :any_skip_relocation, catalina:       "f2b4c770501f815cc5afb9ee07784625d31ceb735c80fadc809d71879a7e6381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "424a8cc7a5e9b32a7a70d987b2ca85de9a111f05ad8a78e82cb1df2b6e65e3b0"
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
