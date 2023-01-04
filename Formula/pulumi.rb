class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.51.0",
      revision: "b2bc5585581dc9b87cc088d98bf4088c9c3886be"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9248d7cb03c0a8d3cce6426b782ccc821ec1d86f93e5a0f582d4b89a7fc50829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a8ffb98b3033f675212dd029e93a3ea5063fb37e220270992c27f39ed4a2ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83f4b1b1d57b2819c77a71c42dcdd1d3d761027d947aad626ff0482c648006c9"
    sha256 cellar: :any_skip_relocation, ventura:        "1ca83c1fceffb08a28b8b2c80f6d3260488da08a435849ba62860220849b047f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b92b0deae9793c25ba0789a66b41e6ca9a29564f713773703c5ca2334da3a73"
    sha256 cellar: :any_skip_relocation, big_sur:        "706c19fb58363fd01622e43d8e2214d579c9702c818516f9f191bab26d4a14eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b6d0a7b9cc8381d5e75189e2637f1c47a1cba6d4a92ffdf3edbdc215ed68170"
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
