class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.197.0",
      revision: "d89552a06391618eee1a9455cd4bcd701810a940"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34df1b2be399bade507ea9b075025b2fe3c32ac1d263d2d55be65827a54a1dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb41e1af13254c33f1960653e1b375fadf74bb3bbbe4285e5851507f9f2688c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39e026fc7edef2708e66fe7906e212378477594e9a6fa9821e25c62fa63cc37"
    sha256 cellar: :any_skip_relocation, sonoma:        "c56b5a9f5a1dcfe7f08ccde74c22dbf3af8d0cd5c6a88ec44e12ec017d9aec05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb37f6a17abe709847ff64958f3102286331918b7f894635005026d1b2ae304"
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
