class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.114.0",
      revision: "88b0dd15a29fc04f9c7ab15d9ccb80e70a83bf94"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "868eb2c364a143c7747a186be7a6400ad33a8b1abbb4ef462c730df6bf11e771"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2489f2f9e1e67c57eedcbdd6939c0166e3f437153928c57719568ae54cbdaba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb681a1de81de4d8cc2b130f040098c8fcb1d793478f9ec51b120bb41a80ae5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c0271ec72e626c4460cfa55552937fcb0da4689688f0eab64b420032fa8dd7d"
    sha256 cellar: :any_skip_relocation, ventura:        "87c22dfdeee63cfc3385a5404578b85d42ed556bb5c4532c48eaaa1143a250af"
    sha256 cellar: :any_skip_relocation, monterey:       "6b492d249aaa8e4996053c36732aa158dc1bac3ebd56f3f1118613974090927f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b31dc9edecaf88b75e02005cf9ea3047faa5299f9d8fc1c5299c22e8132acfa8"
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
