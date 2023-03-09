class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.57.0",
      revision: "f7a1b5a960b19068d71821a72282577529b8e533"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74e5e0ead0cc836f20ea76ad8427993b26f6dfe368b64dd5cc9c2ca4e07e4023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5711a4f106e14729e8fb626868686f6cd8556f02da7e05a77101b12c8301f2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6863213fef7e48a6da4585e536237e5d6c0b3ae67605d7ccadaf9885769a13a8"
    sha256 cellar: :any_skip_relocation, ventura:        "a6bb49763decc35c58629cd3640887026b761649309b7e018f4b8399b58c1eec"
    sha256 cellar: :any_skip_relocation, monterey:       "fc40e10cc8642b552862e31256febdfabf943ad4f2b3444a47f67b7d1d8b090e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad67c719156d0ad7962da25587e65771e7cff5d58710e93c58b20d0d6a581e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c0252cb1f7ed01afe4de039eb3fe7f85ea7b6e337b31f253629191e68c65aa6"
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
