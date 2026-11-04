class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.274.0",
      revision: "e6e7c7a584bcb22fa0e35e7f90c2ed85ddd89bb9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "382d910fc32e9fdb221a52630432c359437922577a9294754b0682b076bf87a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3fc642178044b7ac8ab0a2ae6070e133854467b63102ff461f1cd49531f6b6fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eaa0868ee80c7a879ae5566b060ec3a46c4aff24a762636f5d0d17b921004573"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45fca75f7dd9fadb649cedd9480a5e80608d68f147b4c3ae752c8fd020b86e32"
    sha256 cellar: :any,                 x86_64_linux:      "1d3a6d6754a7f6b2eb33f08e1b9cda1eebc546210434470c6d0b3b96a510929c"
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
