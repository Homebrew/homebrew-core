class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.278.0",
      revision: "783a0060186b6b8d9392ee098db087c8aa01062b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "52daaf4c2e94daccb99b165dd86dd4eb7da9db7596f16cb35e8413b60b808129"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bdb1d59c45f3a8876b94261623e240dd66be5401e10a4f0c8259f577a396eee0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1dc840430f97b47b5d20cce9722b51b6a5ca5608a5b80acdfaf052074c2f3aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f814d608b55552cd1a807faf25fcb3f2aa1b161ebf8905e5f9f6fc454b670c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22f029ede24500d2402c84213ad83f9d131b655582a866687b82af7c5e08a173"
    sha256 cellar: :any,                 x86_64_linux:      "a40a8ae27fff40745e6673b89448b27930c6eb23621517db1e19c2e11ffb60bd"
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
