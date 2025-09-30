class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.198.0",
      revision: "1fd12025810496a1414ffe6c7caabd2c881c7161"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56c95c9b19b3b8be28ffd00b882fd2d483f14ffb1c84542e237bd8a90e8ba5a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3f651d20b979daa46b717b4ee998999fc8002a74f6332412d1de780c67624ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1404286312297ea2134f8f0a407f95237d59fce6755119fdfb80af96cd75998"
    sha256 cellar: :any_skip_relocation, sonoma:        "295ab8b87f869533671b1d24a393152d566477e97f905b5ab187717002e499fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e69171fce668ecbe8990a3f33186e1eec5dfae3ea5963ac1ac49c8ecd472b75"
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
