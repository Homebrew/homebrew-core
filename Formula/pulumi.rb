class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.20.0",
      revision: "a1387c5d6caa1561ed4f6a6e86d41e7258b9c74d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "856e42427f04ba8e536ab0fbb761443c67111d268618b8370a838be3f41264b9" => :big_sur
    sha256 "d141e6b01b14ecaae6a1b089fd4f06ef4e08a2c7315057ac99aebcf9c55e0dc3" => :arm64_big_sur
    sha256 "3227e1ee3292939ca864535ea6b7aebc0b14d714477328114603f7be714bb553" => :catalina
    sha256 "752cedc2fe656c8af86989ba16644b873bc5db112a1dc1d0529dcf6c4413e184" => :mojave
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
