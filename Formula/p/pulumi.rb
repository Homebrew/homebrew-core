class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.109.0",
      revision: "7ebcc42455bd1e0760fba66abbbb8203a206b4fe"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0f61122c84b8e30ba299d6bd759f42eb0152f0fb5f5b3cde5f9fdb217a5170c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4547a5df059a82aadd2245d5d2d542969b56072b78bc63e0f5fa3c7cd96d0795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d894f5464e726811c8411d59f1053d8b174a6dd23aa263a5034f0233e3a142"
    sha256 cellar: :any_skip_relocation, sonoma:         "dca88bbf9fdcc20cb807ed02f33b41c4b7796fe814e7740cdbe6e43cf976c5e5"
    sha256 cellar: :any_skip_relocation, ventura:        "03844633e0b8166a60211c3cc387886413ede309ce1c22e93410aae61dedf685"
    sha256 cellar: :any_skip_relocation, monterey:       "15d1e3308d97ee49c8ab77650181b5f0d18ccf30b2346a6bff7cbc833c4a0324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38d481e7827936d20b44a24e8139fc063cc72eb018c1a8e087a454c3e5f9b577"
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
