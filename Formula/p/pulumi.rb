class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.259.0",
      revision: "0ac56e876614aedf12771d73ef7e80959b8a6fd4"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c13fe214fa350642ee6cc5b9f298d21b7c52b4e69c7aa7f67f152584c086696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a2c5b3f557b0d64a637739e772582a9dabb0b0955747884db724225c69a253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76ebe406e731a832160d3321382a479bc5ee26579476f3c19ea5255905b78585"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aa14fea54d19ca17137ccb22b1e5888e417709bc00337d65b9065a6fcc61164"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b13a152d323d1fac7db2ef18d422b131300590ebade779b3a15c49b12a53932b"
    sha256 cellar: :any,                 x86_64_linux:  "8681918af307e605fcd1975906340d37957f2c2be50eadf2f87a378f28fcc26b"
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
