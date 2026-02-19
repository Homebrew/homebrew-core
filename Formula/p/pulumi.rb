class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.222.0",
      revision: "6a7f5156540b55c4020f9d3d932a82027f26ff13"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "712f78baf22a6f4e596c75f9ad895585473b6a62b66e0d03406f0159e59262ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19e23c8d861de9f343c4bfc7069d01d9b3818989b7c8bdc8f542af599004eb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e431a4eb28f84fc8c1c8f3991339f5ec56d75cb727ac2407629badc43d4b937a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b688179a36772416a2bd3b8f2b85e13bda53831f94158b8d0313820a32399177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "618bbe621d8e37bb77062b21b1e36535b02b1b09cc507b11f53aeefd45f32fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68e454c8071ac12a39ecb594ea83a472c82a5ff4d32ee880e2f73b7a5796888"
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
