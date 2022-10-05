class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.40.3",
      revision: "88afcb12c30a1b961565a1cb7c22fb1e8e620c3d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719eae626091567cd1a3d48babef8dff435e03b87bb11ec0669cebfa27f1b6ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f7f5b7d0b21936a6bf21dcfd5c13aca5d32a6ab8fbfcda13d4523b7cbcaa0fd"
    sha256 cellar: :any_skip_relocation, monterey:       "0b254937ab482d8fc6b06b341c4b7fde9f90ffd69374af25be80091905ab872f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e330dc8a39fbee62aa2b3f0c325f3afcb8b363ad91026116357225eec7691fa"
    sha256 cellar: :any_skip_relocation, catalina:       "4f0dd099c902cbd80dbc35270035bf56ef3c2861c766df080394e1c07672fec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a65bf46a6783102c336c15528c728bacc0d3fe57ea360bc9094a150aaca6ffd"
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
