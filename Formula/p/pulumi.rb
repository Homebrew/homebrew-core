class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.276.0",
      revision: "a4fcfbebd8f7232544eac62176503c6923d931fd"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43e9ad5dcfcaa4a4723acf6f3a4a3387f2443dd3b87f632dd2019a39183c33ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "362a3518675a8e37ebba0367b93c5e58b7cb070b22f707a51ac9b44099365abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fc5dd88dfc89c33df9264eabcd1816cbcf96dc90d50c4ad05d9d833ab3d6753"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e24b7e40c55941dc98185734a48947c371f1dfd79269ba33e4a0ec9e567c02c"
    sha256 cellar: :any,                 x86_64_linux:      "b1bc69a29ad3b2e19990e76a2729b1f89435f18d155c3df88c3f4ff87899c646"
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
