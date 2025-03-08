class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.154.0",
      revision: "23fea44affbcadec526e399dcd3fd9bf44fd781e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d53913822d7968c1b4dd878d55b75fb7952eac92565280fbb827c59fa5c82e98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a0018719591accacb6914655b751177bbc570d1052b4318dba41816de4ad64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddf656b5d3c3dc11b19d4c45ba43f2c7dd409d1363412f6a9b66797171d440a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "66660b360b9fa4e8cc9dd9ea4dc2f623df88b88998f5fe99895c7f45129b9139"
    sha256 cellar: :any_skip_relocation, ventura:       "61606d951a2575a0612442c4b4aa20e7a4c84c7b058c14cae7076caa539d2046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85148b949f68cc9effe458ea87462f216e4bb5c9fadb3986eb4d2f0648139fe"
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
    assert_path_exists testpath/"Pulumi.yaml", "Project was not created"
  end
end
