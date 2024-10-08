class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.136.0",
      revision: "6315637ecef9851f21bd94c37489c4f117c8089b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f323b93f1b17304f63429df5fda13622991bf6c0725b67bda7a65100beab6ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb2c78ace25640deaf5155b1f5a7fe2e9641c0263fff10c83994d35a948506d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bc9d9c5dab7e7656a40db15e1c2a4c15deac103e5be92a3804f0490edc62c81"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0d12a152301da4deec424255b83e7f05e5179d1a2e78215585cd1cf920550a7"
    sha256 cellar: :any_skip_relocation, ventura:       "ef75f980852fecae69f7f52d4b4f7e0b88d830ecc299a04a09b4963109549cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b132862aa87d03b67dacf8d0e16206310f2053c40f48dd7e8c6f566954146887"
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
    system bin/"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
