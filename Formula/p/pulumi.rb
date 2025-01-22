class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.147.0",
      revision: "bcbbcc67c1c6fe043e737e4ce1ae34aedd37390a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13e2ab224456f3f0a053809fd97b03096269f0b789adeda0341ec8ded0f7aab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bded51aee87606aac8aeb8a2009b43d2b4bae32c74c71eab879a1ef86aae60da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0355c09a9e741ea82789479a5380688b0ab4bfee3d4e89c3841ddb6373afc8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2edd7e89b69b870e0217db0b4438a2d1c5ae06838470319ec569822528b7cba7"
    sha256 cellar: :any_skip_relocation, ventura:       "64781374b5b25baff99eb825455519273a3ad86c0f7b8ceb3b8d14fe75b1e4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8279a1a43b32c874d9d35542d9f27f5a71c0b4ce7f9b9a66573b9411b71bfb74"
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
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system bin/"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
