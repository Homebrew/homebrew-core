class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.14.0",
      revision: "a1b6b1ee6ad855ccbc1e1f582a5ff4ee0bb06697"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6bba38477728e378c2b839dd891114f677e183ae1cd1571079a2cafe5ab7f654"
    sha256 cellar: :any_skip_relocation, big_sur:       "da783c46dd308e88d44c5c6fab9bac46c8ba745076ba6cb8e41eeb6d7f23355a"
    sha256 cellar: :any_skip_relocation, catalina:      "5a12640b29cb11d7879e3f85d910ce666f5669625176dc303b3a65a850f4478e"
    sha256 cellar: :any_skip_relocation, mojave:        "c1a56c4162598b4f74ad17220c312d7d28e486d5be073000ab9e3e91e8532620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "597cb6abc3b38389746eec074609adfa7ff06d534bd56fe5b669ae555477063b"
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
