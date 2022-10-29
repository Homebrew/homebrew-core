class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.44.3",
      revision: "2710691c00cdc3e059c6acd607c03b8b818fac90"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8de5b98412f42d9f440d483bac9b5e5a471f41e7ef4f7986f87f7e8ab453b5ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79ab4bed66d828720e47c3cdf3870eea2e60d31c1750670d3af4dbcd45f414e0"
    sha256 cellar: :any_skip_relocation, monterey:       "577a888d677ddd308dcad023b2f357edcf5b32d54abd372143782fa8bc8d0854"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6155eeb5cfd5bf88b90e515e3552813f763948af427ebf4148399ab316af4b9"
    sha256 cellar: :any_skip_relocation, catalina:       "ed16518c93637bda4cb7d05d9d82875528e014c114059fc0f1d91b55bd859059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89d896ee3a883008a02df3b42c9d0a5f58227aa7e16fda835a6acbd15c128bed"
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
