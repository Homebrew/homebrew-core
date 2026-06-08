class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.245.0",
      revision: "d6021091d65f4f098afbd6956460cd2100bc0be8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8be0dadf47dc43c8c2d38d83b6018dd9302305c607cde63551ac4831ef6bc24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4e1e0cedd096885482642d665670ae738548734b5f1f5cc8621ef8181d940b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee0c52c37fa1b23115cec19c27868f036184827980062b8450b2ba15a621df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f6acc4f8885fe74b6237418ca62d6c7f201a752c643df8e506ab6688f68c0b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c032f44480c76196b688bc0abc4270312e4bf4dfad6bdc1e2224731f613fd614"
    sha256 cellar: :any,                 x86_64_linux:  "18bbfd066c51e74005431a797c29641cfb6550b6c272f3c04509f658f8833d36"
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
