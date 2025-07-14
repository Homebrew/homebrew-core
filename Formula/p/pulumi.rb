class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.182.0",
      revision: "997a0959c3a1e7e4563604d1d4f4810949736c0b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c44e3d6a57b7bf20eeea75eed1e55a0e093b5fd03ca0769d4136d2221478c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cdb75f764a25e8c62299a3e1ce3bea24f8c2bd352713643bf2e637fdb53318a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10147767b3180a2b0aad4b77559e6f86c4928f1164f0a3dd3dd6e2831eba53ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "78ea4b91369fb31c4bc037090e1fb2ba815a54f23925947fba87c541c701f0d3"
    sha256 cellar: :any_skip_relocation, ventura:       "f53427bad71e1e84b8867e39c33dbbc2266b63d4c00c15af1a79015d027a9e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f85f9bfc501c388a3a9ab1886da896c2c4e32b57a584e41a2c243721f3c593a"
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
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end
