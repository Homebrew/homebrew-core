class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.215.0",
      revision: "2ff3425c8ffe36ab8c19fc89285aa59685efa332"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068f78019a3a0685562053c42c1a1a0521f33f3e2e9435038d794ded33b7dd44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40771b2ba777f64ada252a8f7c0be4185f1c202160723eb70a9286364fc2270c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1d4ccf2cd1658cdb3f746d2b63f53d7ca83197594fd14969eff8c2aae953553"
    sha256 cellar: :any_skip_relocation, sonoma:        "88c19d0d5e0e2ca5128ddc03cd32a4140a8ebce12512b036caee8834ba6ced48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11768afb06c13c345bb6419c0f9596af0bfc5bd2483ac32bc1f0dde1c4ab5ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67a0a75815a084a0b85b907df4413e218cb1e5ffaa73d156e3fab37d566af1b9"
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
