class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.48.0",
      revision: "189a0eff7c68d3d30a2c0c6e8344a4aa125da871"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e3727c1e07a7bb316a582dfac8b03d72050399b8d826cd5c5c3568cc8050af3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9ac84a3b10120b81c608d93f50b86666d080f0d3f6b31e30c8c4187d0906c6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a244953b91a4d40dc8a5d7f61713d7ad16bc6aae1811982e20d02876ec48db8"
    sha256 cellar: :any_skip_relocation, ventura:        "617d9068b82d3ffa8b12edd979f9bef4de0b3e81338c915dd58a5b901ba7e34a"
    sha256 cellar: :any_skip_relocation, monterey:       "463a9bbd74652efda811f76c049397a5bf0455ae453c1e6bbe1a5f6724c247c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "31902f08e2673b6810a8cd3e6ea6efe6dcca5476a306b28eb0973a7a06f99adf"
    sha256 cellar: :any_skip_relocation, catalina:       "c59549cc694f2e7e4dbc535e8fefc7ea6d818854c5ac8ebd8504f62c6c9ef799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2adc0adfcb0c81f705bec98f24bc727a8217c7b75cb6319d0552c940e9017e30"
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
