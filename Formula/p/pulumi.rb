class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.274.1",
      revision: "8f735e662d805b7a5bda70931bd627c69fbf38b8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4acb46a51f2005c4af28a38de3b79c9cf20e80c09d8b88d143298e89390101b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aebb3948d8edbbd002ce0a16fb9f901b7e4604893906c37455d60ca5f6ff1015"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c0e56b1518daa85470b03ab437709993efc86d571e2be3b56b0b9adbd9950be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45937c647665b007f4d8317f3fb9cef58e0b232affb59a136b3ca4a45cd23f76"
    sha256 cellar: :any,                 x86_64_linux:      "e69772420c2ca18b12cc0421bff53b99374f7372f5dd6b46c925383d352eab8c"
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
