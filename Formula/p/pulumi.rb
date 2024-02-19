class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.106.0",
      revision: "1c68e3fc7770a3de94d9e6e42fc11833b609cfa6"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fac10564ad8d743099aec57710de70b8561c28a94407d23c46684a5c9ecead4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "445f108cbd09d3f9713f24763018a1ddbdac5db56f12fd89aafefdcde29a1eb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11e1977fa198d408a31e36fb6a81bdcf969d23c1d89c4b77f880ea2c389e7aed"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6303de2852536cf8ec131d25359355b360900e84d3a0a94ae46f341088fe753"
    sha256 cellar: :any_skip_relocation, ventura:        "32fdedb0e9ee11a6fc2a6c79fe05d8eb55f8120e6023ef715ec2c08192c30820"
    sha256 cellar: :any_skip_relocation, monterey:       "e950c111667530b5e6347f774bd41cd5e81dc7ff11700b37c84510108950ea47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4edc41bd9246bb4cedda23878a33b3d66e506bb7fb344703ca38ad3c0361344"
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
