class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.236.0",
      revision: "7db07780c11de25e756f7142c93204d73dd0036a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e6e5e3d19db7f2afbed03113e7ebab2b9915b5ce743b1060f996c1b6180ae20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa94611be7cfad519b484674739a92a5b748efcb7254a0a3b06b9f0f9a21fcdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5306d6f745ccd2fe6bd97dccd5411149039ee18e3170d0915a94f87ee4cad803"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26f17ba7c4dd7e67cbe3f1756d72189d806940212515a889ad4d912516fbf84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ade03cbac29da785ebb5de3909f76cd55f66a4cea862078f12fe094cd9f704a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9de12050d252ce418071b4f224ecf6b5bf4545b8c064a08e6ccb30b7106670"
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
