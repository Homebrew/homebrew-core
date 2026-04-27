class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.232.0",
      revision: "59d156aaeaf3f485614e96704c15a00cf085a262"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e207754bea907d70b807b8e79a27bf3b820d4da17239a051587070869f500b26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35f0aab198e3a3524f2190a43241e3a5d58607869a450941469757e25392ec14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "664e2fb4b296542b3b2590e9a11eb33a7002c9dfb9d5aa1bc287e39c8596f789"
    sha256 cellar: :any_skip_relocation, sonoma:        "be46c1f723961c885e3b571d156351f2cc917b98254198f83d60a2e6625dc851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ff7ace27533471ca0a136acb2b55584b36bdd5d4fd9b7992c5b552e45328de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "808404351dd98d2ccfeb381fc43c90ecf16a7944f2089df83dcde13ed2945334"
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
