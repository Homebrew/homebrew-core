class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.39.3",
      revision: "f677abf06be5a358f1e7204ab9d6c5de54a9f8e1"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1b4431163ba14810d7fe2783e9a30dff88e91f7400a69c3ee877c5da5b853b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e81b37203cb9c661b0733f9e3ccb1dda98724153b228278ec624072756ca71d2"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f8ff3ba05d1f98f6d3b2833fb2ba7dab2657a1f7c1453dc02f44fe14560543"
    sha256 cellar: :any_skip_relocation, big_sur:        "46833025928c15a06d72a2b91cc24c017e373c368865224b509ec45dd669971a"
    sha256 cellar: :any_skip_relocation, catalina:       "1209e31ac4bf93b55093ca7211c203d95a733eab081b90277b1419bad19aa4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112d3b9c143ba104343ceb0fda77d858b0a90c91c1518070a6167a0dc4e091fb"
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
