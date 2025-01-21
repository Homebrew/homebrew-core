class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.146.0",
      revision: "7d4fe48315994738bb7a41f38393ce909859a13b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa719ca2d9c3ae9beeb1d7b4246986c30c417628ef602240baeb8a40c77c7e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b74d78ffc15a8fdabec9804c992f7c7a906d5af36fea4bfb152e8269f5cb02c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e032c9d2295f8bd0fbbf6dba76a13b378c5b6d594ee358792200ec0194a87ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a80000707a6f64a00041c7da0c394cf39a790a2a2dc3f287da75b95dfc19ba"
    sha256 cellar: :any_skip_relocation, ventura:       "210e649a640195047a4241d63885eef7d542d2a0d29d2012d825303404459a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929c79d2a0ea0ca80cd3702338ea541cd9e303e175095f46a70fa35f8b5681ed"
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
    system bin/"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
