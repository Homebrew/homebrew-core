class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.239.0",
      revision: "b618cbb043587e869d72fca76d5ff4a6c4fe302b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96cdeac60b6acbe99c17558630ebed6360dea6ae8200232ea79bd364c3901c92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdd54ef55de49956f6e456576104e9c7d06137a44037e1b1519a9002822fc7a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f0837e3f56ef767839b3a4944dc8ffde5386a41d219025473c0eed251963a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "06d7ee2237cf0a2fafeadc6073ce1ff94ddf21ce82663aed49c5da03138266a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2875ae00f1ea087be1dd5250b49ac6eb5d4cd183383fe79569010b67b4f067f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbcd4705265e5aa0e073cbba5dad88a0e06b0a37847761132dbdc4cc1bbdb4a9"
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
