class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.200.0",
      revision: "0625026c40cd6777945f9190a6a497ee66e707a4"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "662ae58bf72d2ee818b2fbad751c1dc4dda62f5ad4180e4b87f1b4d2fffe88d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "170eb2412298fd08bd16156689ff971cccb2be5dfa393ce16b816609dff63fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9badd862e7424cd8b6df6be0e3dd3c576d8fcb9e64ec98dff1d888867409d936"
    sha256 cellar: :any_skip_relocation, sonoma:        "bac8b77a32136fd5e2adc7f4b3f9f36e6de69d44a01aa2643c4397b63f7bb552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51cf26970a3ef22a22eacec9a9ce094833564f1d4d63eacaffe675a850bdc74b"
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
