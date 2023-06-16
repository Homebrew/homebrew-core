class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.72.0",
      revision: "3775028c6f8767f136aa63af05ebadcb179e2a3f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a6114261c346efe791a4f9d9c9cc64ae938da38939d86ccad4dd90af30a1d67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a87de7ff57434e5ac6378b4a2f98042471c2e08487ceafa432351fc2885af9b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99ba652692b00f287f869a87a5cd5affe8fcae2e32054733036722db37096c11"
    sha256 cellar: :any_skip_relocation, ventura:        "d74150a76271424c50007551c9c5bd79adb64c3bc1b711a57ee2d532749a5b20"
    sha256 cellar: :any_skip_relocation, monterey:       "e57b7f02e853ffc26debe314bf6122de2c7efb206974195b8edaa9b5d043d73f"
    sha256 cellar: :any_skip_relocation, big_sur:        "afd428c82e12a5c86a09508d403e1caad5bd74cbbc00f9bf97e4f936276981f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca38590fe5c79b6361cec7ed41346b9fa24042f0d4d59912f84af22788efef74"
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
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
