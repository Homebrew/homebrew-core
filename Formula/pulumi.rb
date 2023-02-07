class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.54.0",
      revision: "4da1149be738f62ea841228d0eec7a16dd7b769c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "776a9d8461f0be075b1a04903c8d1f7979e4fba3cc5d1ac46dda795a6ef4109a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ba928372e16b352373199d28ba383e75523f09580ededb958ee65b02302286"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5f3fd29d8f0eb22afbbdaa2c2759f02591fff599bc6742a888ec24e61432131"
    sha256 cellar: :any_skip_relocation, ventura:        "4a20ae657659aeb793aaa3b0ed63f6ee3d8a378f6f8612dcecfcb8dd6d60e9b0"
    sha256 cellar: :any_skip_relocation, monterey:       "b409c72431b0455d9ec59dc51814ba01366f792be4a021cff034ad9ee8b8507e"
    sha256 cellar: :any_skip_relocation, big_sur:        "49090df4063f2c1e87ca68d2cd80513de7019d50f56386e3b54ae6fe5abecfb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2508c618054d74989981265916f1e8253ab3cf79925e3a19bf0859931106a837"
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
