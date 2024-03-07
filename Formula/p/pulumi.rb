class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.109.0",
      revision: "7ebcc42455bd1e0760fba66abbbb8203a206b4fe"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8eaf56076f14a5e44e6214585f54ec98a34f0663330567c6b85d9a0bf8cd77f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "222917fb1988baf74f8e4e17003a0649e8993d84bf281db696d057cad65676cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef42c6e5630fada644b363e0ec74be00d092b529ba4d57750661058444cb78f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "52204e5991a8af232b9d9caeff6890a59754c0e71c5f682fe7d074cc49bd3df2"
    sha256 cellar: :any_skip_relocation, ventura:        "4057b4e5a27ad0889c2b53220a07a680ce535437bfad1f3d0e6d6fe75340d39c"
    sha256 cellar: :any_skip_relocation, monterey:       "6ff39f18b8560195c58d06f901dcb652ef59a0f39e4eb676696de26563f1d1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47174355c47a3dfecdd85b707c7ca8e6dc506525e21af6a79de3830ff8c0c12c"
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
