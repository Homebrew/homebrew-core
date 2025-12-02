class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.209.0",
      revision: "19f75d40a2b30999786ddd9a8f5f073e7ba9ecb9"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba4a551a248e30c6b7f06cc66c39ceac178c4a8407bef05eb6d95632e686c678"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "088fb1c19a5f5ba51ac846b6ba346b5fbe9f33ffdddbaf763f15f1dde6dbc1d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b28afe82ab1228ac1e7684ca33bffd402e3def7e340c526270132f7953a03000"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9f35f3c8e51521d1dc4c4a61a658bfa99c8aad2341b48ed5e5e0a02c285428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac3d164c3eefd3a1d969af532444d255d1840e9fcc7ed7bf603168464a6b4e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e001c58ca8cb277158862904734275782edda4fcc5064079eeaab3762509e58"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end
