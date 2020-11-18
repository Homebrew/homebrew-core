class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.14.0",
      revision: "8ade2f8319af26969d349a40d0777d175e0d10c6"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44e968a88fc0cd579bf17bcb41c6342323899a0a13e5883af2bfa1861af09106" => :big_sur
    sha256 "96b3d8aa13b9a7ce716459f5a2d6010d655c593d35228483df5acef1b6448cd0" => :catalina
    sha256 "8b8732fc52b414cfaa92deb580782e6088079eb5f9136e1c8e43917b7e7b5c2d" => :mojave
    sha256 "d0c51ef71670f4351f18a672c06597e06a0eca491454b48d51f3cb242380e58c" => :high_sierra
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
