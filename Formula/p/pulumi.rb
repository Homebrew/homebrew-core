class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.231.0",
      revision: "5aaa649fbbfbd3511d996e9e33b415f085b42709"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52fae81eb62a2e7601049ddd593e5acb3c447985b5cce7a9472416934b934c15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7659736d7648090db9510bf2d0e570b305afa6b8e8195381ab1178d579f61cda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fec5bdabbfced2e42dfdb7a865bffb460e2eb84248e62bec7a6768ba72089887"
    sha256 cellar: :any_skip_relocation, sonoma:        "633942d3a34a0f91cdbaefde566db84c067cea793e0cf5dcfda0ea5a495857cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b61eec4eff1c1916144d54e6342e3412229e1af3d54c163f2b0471a0ba1b441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0a184c2bb23b9546cc7b151e524aa66107a114d6d6fee485874bd8d4a726e4c"
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
