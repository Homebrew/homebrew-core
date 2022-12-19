class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.50.0",
      revision: "87764984c8308557533ca32d0052254b2e97b9a7"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "327f5d32d87601fef817ce092c3c9848bad3b89ee6f87cbab8f78c6a61bb5404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ddd82089c47c32f09ae3589caecdbf9804de66ba9ca5e4fc85854f8ba9c3f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6677775ff8c7e6eb7805568e4b711c04ce2f95a6c81d62fbd0a9511e4bca0a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b99675625e32c0b488b839f25b067382a8be66df7744e6532da2599277ba07d8"
    sha256 cellar: :any_skip_relocation, monterey:       "6f964f01c553029eb2e520ece114ee2c0a3375c1ad003b7a841535cc229fa478"
    sha256 cellar: :any_skip_relocation, big_sur:        "295c06cd1a53e0f9aadd7f287e50d23be26496caa70d0ff83a800564e563083f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d99c889e9ede46724f89eea4e9803ff0e361c29ab5f6b52d03bfaa4b3b9f98"
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
