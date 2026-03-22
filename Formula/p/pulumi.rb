class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.227.0",
      revision: "d92cdd93da3ed6588a67fc1711abc623bf1a04cf"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "548eeb078222ae1d84abecc9ab7b23d4851170d92dfff360c1df08520919ff7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c1732b729ddf974217f38dd0a61442f11c11640c568f76fb368353683a7a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d70533bf72d568d4e6b9fc0bbe07ae01dc57c33c49b90c20e875648280d1845"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c070276b795dd3c2426d20aaefae8d6f6aa293670465c2875759e5c4ac5469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2a22f4bc251455c64291db324f5e5487ef430a8dd7c8bbd8602e0c47e2b416c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891d77b8dcd656e7eea3103732119c16b7384755ac0637f4eb644c899b2fc66a"
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
