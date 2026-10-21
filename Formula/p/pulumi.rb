class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.270.0",
      revision: "4162541bb475bf097aaf858776a3a0e777e4889e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "772042849b0ff4111fca74bae82840d4f75ca532ea986482fc26fd08ee94b52c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90e19a281b53110f5134441d9aa9149806282d9f6ac8779806a235d501af8dd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7df7941148a99156ec78d3c0172687720cb385e90bc3306d314982fa5d62d948"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dac7973cb9f17c0e5fe4b027148ab8a0346ea36bc13a18ecee4ac7399775c72e"
    sha256 cellar: :any,                 x86_64_linux:      "de8f4895dcea63cb649be47d1b4f362076b6549c8bb5fa1f023356c3d39d749a"
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
