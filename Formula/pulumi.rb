class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.41.1",
      revision: "0dae69b079844671993440f6c271916eaa9a1226"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f34570f022868c0e3f0e570504ceb5b17a647ec8cb8f4e090f91bd77b08d67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d863467698ab290adedeae3b9699526541fc967d50c46a2a3d314835b5e6e8a7"
    sha256 cellar: :any_skip_relocation, monterey:       "bf07b2825fdd4aa8e0a901c7eec3fcf47a2f25348ed250d32e3223a0a16fdee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c0b86738e764409e722b2947bb9de9f200f173e657c1f9c957c137e16c14ece"
    sha256 cellar: :any_skip_relocation, catalina:       "3bfb814904bb36d5c149cf632688d9d27ef5324945f6c8380c0f88ebbddf46c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b446e76319152746aee0def6bec993dec772773e0c9daea4a5607943ce385449"
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
