class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.43.1",
      revision: "91a6b36aa5211ac6d53079dbb36cc001c230510f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6160307dbe32ca87384ea2a23e576e17f2b49790cd39413b0c564fb5a7134a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f616a75ae37d60507d0f9fd29525c725214a5bc53a5b75c9fee2a316def6b4ce"
    sha256 cellar: :any_skip_relocation, monterey:       "d4b6258cf57a0469e687ff6a2e052a8b14e327bd2706c98847b1b1e082ff936c"
    sha256 cellar: :any_skip_relocation, big_sur:        "62354caca4506954196db66cb12c93bc44343198c7f121d1255641e4eb424aa4"
    sha256 cellar: :any_skip_relocation, catalina:       "6101c33066d2b71eff88c9c72da718d2fe37209f1a70486068bf1dd3335655d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1360699ec4e9d5400dcb6aba01cf0c88635cc6dc7b32a5c92dc576b5466f2c55"
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
