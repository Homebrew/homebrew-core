class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.263.0",
      revision: "ceb2e86de7a3aaa97c4fd9592ec2f44cae8afc90"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c7daa295142fdb871c6c5bab806b77f191fe87ad6aab8575a51db3c61be89da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "519bffdfd756e3ccdaa77ded74476cb91908ff3849f092822bcbbfb24b3c1347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcede01636225b0dd0f050d49e147dbd806ee91d455c59bfd4cbfbb14819864f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "480d2c2b82012d6cb314bdcde33670db5b39a9c419c51b0441b5083adc2936f3"
    sha256 cellar: :any,                 x86_64_linux:      "b92e23e121c2dcf680bac3562b587c815eb3ea59cb7fe9f70be22ab6ad653085"
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
