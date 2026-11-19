class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.277.0",
      revision: "a95f099fa05b8c561c511e0a1663b6bf4f2afafb"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df7cccf6b40bbe0d5eac443a1221a57182b0fcff90d76abbca5186f26c22bd01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b730d8a09be068ce2ca1f79788d4f4433f42a2771c8b146826c36c7f79a0a37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ed3944230eea3f54e44c0977440a813cede3008d4def2864b6bc2cd3aabe021"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23cff6ddf57137bb3efd1848dcf3d7a39090b0b111423e37fab01d66e55a17e7"
    sha256 cellar: :any,                 x86_64_linux:      "e62ee3488282fd8099b004a0571888f90b3683ccc0d1c4b712496ba1c21076fa"
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
