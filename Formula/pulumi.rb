class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.31.1",
      revision: "774c0d7f20c46602df44ad4ff33e295cab51d949"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73cc94a694d6fde8b31ed9d9e3e17471a57f2b955c9d4c30a5270b28894e5206"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "853ac18c42a729318dafcdf85ca1d3d8cbb6d386030adcca8023965a60e42a3e"
    sha256 cellar: :any_skip_relocation, monterey:       "9cddd01fdeb4f92fcf7e80bce7c4a3f04ff0c4b0581e59c065a6f10b3475dc3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4621fcec8eccdade5ac737129f90517328ac14a7993c2d63eca202f7400829a"
    sha256 cellar: :any_skip_relocation, catalina:       "db0e1f694f5febe57c7d9d8ac3fa70c2fffa750312c0a25bb461040a588e1137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4732807b1a5b2ab5311acd898c8eb84584ff2d7c7fa33d9f036971f0594ae1"
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
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
