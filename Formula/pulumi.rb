class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.39.2",
      revision: "a81edf8345e00fb8efa77d520ecd470d5118f7ff"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "977cc71ba22b9cf65bef6342c0c9982b0fe3c4069c3a26c983d3dcfacc003dd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31b8b18b4e2519192b5f171cde12bdda0beda70384a87b2b32e452a75feb9b90"
    sha256 cellar: :any_skip_relocation, monterey:       "b0772bdf0feee46d0aecbb768970f7c881d2773271d6aa841d03f5d5e2235188"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dde56ed187ca9acb89c27d7f9d8872106ee36c0d039a9963cc36b2ac773500a"
    sha256 cellar: :any_skip_relocation, catalina:       "217f671bb8cb190d2dc3e1d81328afbfbf8f641eb97dfe8aa183d0fb050d7f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3421590d1680a4560f06dff6cee6d5c7104078e1f9a144b180a5eb221c99ed"
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
