class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.16.2",
      revision: "58c07c52c8d4db037c284b66d432d96db6081ca9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d1052dff25b21a25e77e50a4785e6b159b832364005a3230ffb94e89f8f81a9" => :big_sur
    sha256 "0336d01dc5244ff270af4b45d1a5e263555fea2c1af1ec4a5096e9d90a5ff02c" => :arm64_big_sur
    sha256 "ca0ab114d755bae2820abd2ec224fb8720d55c7b16d78002912f4427f6cc1a8c" => :catalina
    sha256 "7e6bfdf042840891225e7e611815b28e7126d8a4421b6ebd9dea76d3c987c7b6" => :mojave
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
