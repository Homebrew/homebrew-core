class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.251.0",
      revision: "aff0ffa2cc499d598c71d6de589592a132f042a5"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d0c519c1a60e14f9fdff6271c9d36e5e2300e4f62b2e3784290396439d5b51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aed2f10bce5046967c5bdd96076156de63d78e69b5d5d1e6907a45d7de20e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d327ef7ab00dc71ccec7fdac63ffe22f00992a3a2b458f58ac57008030ef758"
    sha256 cellar: :any_skip_relocation, sonoma:        "da8be981788baaa8b407ed2cc8c1211408dab3cd144e373c4c20a84805b3bc6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a677e35facbf9ffa9d9b277ed429ddc58426760eec3bb90090dbce60dbde27"
    sha256 cellar: :any,                 x86_64_linux:  "11c8fe39cf963640e018b809b15203bd908ac0e48f7847c418455d7aa060c0d3"
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
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end
