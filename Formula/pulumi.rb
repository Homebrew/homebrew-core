class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.44.1",
      revision: "4ca146e5bc80d5cbe5ba6896a7f9eed2f2134898"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36cd8d2b3de826cfc746c1b125abe93454cee4ce3dc1d70b49df3cc771c15b5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b4d861893841d8d2e304d75823c6309d8214823bef1503a046e9b8dbdd23546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b63864049e71d7e8d9eb3b2ce8346c41d3567503bd5ff95864dd2db4735ba4c"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d35aaa7265c2602bd66a6136f574268e1b278a79d160c0a34c791316dfc68a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9edbac257835000f3cb3e5725dd6bc555c29543eb321659a3f830fb9750a01c3"
    sha256 cellar: :any_skip_relocation, catalina:       "c03e69c6f2e0f54ae196d89fa72b55071cc3229e7e623626a01d9e8e7f220e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76eaa92861103cd4744ff940cd5075340bed93057346be21eee5dc04ae53b54d"
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
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
