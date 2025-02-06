class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.148.0",
      revision: "fc99b9650f537e2b206585d34e8b8d732ba5b6d4"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c52b38a75d6db033f3f87cd42c5c3e643e7b1034be0d1f7d167884992ba77d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521ab3640611c0356514c1eb1ca49d3cdc0cf18bcb129751a5b8a03bb66a20dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "192d6ffb74d4c8a4b5b77f9859ead6a44f2af1d3b0832b7015a566b280b44a44"
    sha256 cellar: :any_skip_relocation, sonoma:        "95402682b480c8e2778f98383614081ada75837f66c7dc64169c3e6441643327"
    sha256 cellar: :any_skip_relocation, ventura:       "afac5f0b47acf733a9585ede84e32781ef0860d6640fd3eb6574f813aecd0e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2778af332bf8627e90edeeb127b9f7a2001b71a29e001893e82462fecc0a0b72"
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
