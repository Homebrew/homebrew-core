class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.275.0",
      revision: "cc3a399d789290e4d98becbbec4ffca3ad30230d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03ee58e79ab097e29e0b3663d101d168d09ebb4de333e26d9e5db75906e20303"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18e4a552b2d7cd1d72d26ef7492d719b2ce3ac31e6ede777e818d52e283e156e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5103442e2603d64bc253d0ff948982073dd32363c48b17d512571a3bf4d4cc22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "be6c88bfe1e7e3b17acd9296069119a17c2658416c313c91dd322547b82a19cb"
    sha256 cellar: :any,                 x86_64_linux:      "9b2d84d2c25dc2f012a1cc8da4cf9de49f276a6b227d4ede3791224406b30327"
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

    (testpath/"template/Pulumi.yaml").write <<~YAML
      name: ${PROJECT}
      description: ${DESCRIPTION}
      runtime: nodejs
      template:
        description: minimal test template
    YAML
    (testpath/"template/index.ts").write "console.log(\"hi\");\n"

    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new #{testpath}/template --generate-only --force --yes")
    assert_path_exists testpath/"index.ts"
  end
end
