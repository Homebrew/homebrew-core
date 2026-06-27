class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.248.0",
      revision: "a88168d865b7fd428e5a929cc54aeceaf72d203f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2de22b371ca015236b5c472578b900808474ff167a4b8bbd095d9e6cb492d66b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65813d0e510eb3823d17ba218c188094f220f00aaf1603d32e86a735180baee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e0a5dbc8301c6b1ae1df3ca33ead851b1fd269c4e13100376d2c06e8ffec5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c86fb287fe139e955f71756a44a9cf07cc5124f198d5d5d78f45f440a9be239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2b7fa5180cff86be56981d78d70550dc59a9c145217b9a3c9f7a97a7d9b9c67"
    sha256 cellar: :any,                 x86_64_linux:  "6cb9937c2e0b6e532336fc27214aa4012113a2d1456cb0b672c160d98b102601"
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
