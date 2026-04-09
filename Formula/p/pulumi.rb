class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.230.0",
      revision: "ae2e269861eabd2b692984e7286bec78777ba352"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90bd71ad4357ba1c7f56b09844329af576f768d4aa6c82f31954dd47ce646572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82cd22c63452edd7ab55fbedc57ddfe4ac98606af4c177ab32f6dcadc1692c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29946a63bf9bee0ff2485ab45ea8a812dc3459be8d086c6a87c28b29fd10d533"
    sha256 cellar: :any_skip_relocation, sonoma:        "efbe5979e649e1d6798b8665ce4026b5b9da77b5469eea960be6aae3f8a5ac21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af4579f63ed0d389ecacc4b95cb858dab0f7820f7335c51a64b948b583e574a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbf7c1a31879f28aa22e61e7aee9cffd69185d610d47699e7c4e5165d04a2d5e"
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
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end
