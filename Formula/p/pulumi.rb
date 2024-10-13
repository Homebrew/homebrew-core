class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.136.1",
      revision: "08dd376cebaf193509c55703cd1e3d359952ce6a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69b68c815764ac4fc4559831f1239edc38cc7c888b833d2ce4cdf393fb8e438d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5ffc9dbffe686da6939945a8c8b7c21e4b003dfe12caf8b68d527138630d2d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d999da252899ec6d4de18727ea5b522c81c8e448ef3d65c901f85a4422409736"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1719d8d315b5ce6a54cf6882f77ed0464fa303862b61338d901eb65559428fc"
    sha256 cellar: :any_skip_relocation, ventura:       "0ae3f15a559eca29639df120021b01df71f7109ad03cd6fb376f6da6b8b80620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09141af4490c2ddc967e5ee9b6d460f63f0d23aa40c5c46a6eb8aeaabf0aadf2"
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
