class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.225.1",
      revision: "511dda345a12fed24bbb3cc828654e5ada8bb3e8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4bb8be68787601d787e7ddc82ca28b61d3eee54d68b5aec508cb669571d18e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e1553178c092f4d8f94f610658845bfecaab757ef0587a34e7451bf6cdfd22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae58deae65f8e369106d2de8fd3e184d5b88b63dc1b021b6f9312abbe0972fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5ce41381a267ff13b7175c81a7f05ef6bf50268d3e265a6f8296bb585204f1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7df93cbeb4ab94f31fbb2de7aa564a02416f25e4606552b6cc80457b161d4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "934902e74ef77debd99ac9e58b79e560babbe42610ff4881e1135aa2358754c2"
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
