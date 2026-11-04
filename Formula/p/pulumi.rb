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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acbd5419904da35a551e8e99f63a545cc6450a0042d68976a9971ae589ec2dd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ff64b42f0d778efd274f5bd1cbafb3bae24f02f18639ca00fcef8b3277151de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "594d56b44e211035fc437a67647be59e7a7d4614aca63fe2842af99e0cbd5994"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06c6af8ede4786b23844d50492fe548d99543a27931ee266845fb7764cb4ad78"
    sha256 cellar: :any,                 x86_64_linux:      "0530a1548c0ba14ff754823245bb13b548fb34ef1b85ee6416f8a81ceaadfb21"
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
