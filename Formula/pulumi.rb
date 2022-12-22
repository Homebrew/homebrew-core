class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.50.2",
      revision: "9eddc8ab041bae07eca911c34c9eeda39bb7aea3"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea03a64a01c6d2fb9356a27d66edab532b8c9eb4a855bc509b1401fb5226c8bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad474230598c5b53887a71f507ba16f07c5428b1e8f44ba7f5b6fc0b91e7eaa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37fa8f0f2eef426f1d3bf5b5994d2046d6b2fde06666f4d90b20d52b9d045fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "1a0dc2c3cda30a12d3d68bdf522eb54cc18f28f9598fc585d1d28571931344a9"
    sha256 cellar: :any_skip_relocation, monterey:       "b61e8cc6460984b078e603f0936529368856a7a369390a240ab77eb3e2395f3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e8d9828d80f9cd44176af9c2bc96310b5186844125d2ffc47a7a6a7e2b41013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27eef70e92eaeca32c314be71451e4653655401093c3dc3c12583ae4d77dcbb7"
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
