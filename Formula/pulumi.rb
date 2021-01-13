class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.17.1",
      revision: "d25b74014edfa1549e98990ae9efbd0b86f4d715"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6425583ec9f6a8ec9bd7b1f3db6ca04a84885648f79a4422a9317cf3df1ea69a" => :big_sur
    sha256 "90ff8a66d8910f6224e59f72b4a69bf36ab7a4635d7a03fa96c7f127d07642ad" => :arm64_big_sur
    sha256 "8b15b694038053f2c3e5d4a9868b6bbb45abc7191766fe8a3357aa85b1c76714" => :catalina
    sha256 "b144295614d53b34b128aba96301df6720c5a74a1c40b5d092e7eb98755c36e6" => :mojave
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
