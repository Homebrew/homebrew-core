class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.196.0",
      revision: "4aca447a990364d6580edb290a23c3b61ed4a423"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fabf6f13afa0fc250d09bea2c43edc40a84c46f797f99459a4f50498ddafa317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6b01abbcab0ffc198c57529b8b6971478f0ed3a13afca9c6d640b4185b889b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b33e2f6a29a39755d274e53502db81b534ebfa8a2b16e8161ff579dfcea90c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1724e06b7a169b7ec117ac071a6a72d5c1632c5a673ff64b585717943b655cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b62868c73a8dcc556d8c7216e51f64b8573874a311a2045cb11eb302eaf8d339"
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
