class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.43.0",
      revision: "761d1c74eb334fe92a16043ca9d2d98a905fa90b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddb063ae54ae807184c4f5a4c9231bd72d013944fa8ed482cc9a5f35771cdeb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78c902abea46eae5e86b7a452431052da203b3ecceba2467d102084f9f06bc50"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b02039e00c2c654ac6f743aed91b3f56dc73a783b2b3df51f3140ba032cab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cfa9fe77428e6cc7af95f149e471541faf97cec48de6660e60a606bbd8925cd"
    sha256 cellar: :any_skip_relocation, catalina:       "d0dc703ce2feb01cbc786bc8b92b622d7b752fb5730973c4ff1c8a1a9d2d6c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ca554406d7c926b2daafde19810d382e5713da65ef0ff15e78da317c4b13e6"
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
