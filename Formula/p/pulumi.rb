class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.112.0",
      revision: "1672ba246fb9f082e9bab020284668fad5216d4b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb1f65be7df1528f6dea8b9c923a10e4328f31933f6e1533296036c730c2af80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f01cb078ebd1d33c837918b1d5089790779b0d53d2ff9e9564b30cefce561639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e59b6ec8b0290eec9cb336c2f7d9cb437f10d6db282d93896231e8ff85dfae"
    sha256 cellar: :any_skip_relocation, sonoma:         "387e08997374880e76ed7e68003e08fe39a8528c4130759380af963b23dd9b8a"
    sha256 cellar: :any_skip_relocation, ventura:        "e1adc7fa770b154cd713c14df901fff5131fa0ac1c1424826e6cd0a52383ebdf"
    sha256 cellar: :any_skip_relocation, monterey:       "6ddbccf9455ef2c5b50a554561d72a5f60aae5c3caf3992bf8410ee76f6dd371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72aaf344640cfe886fc52e7b42ad82c2ce252058ffeffc5e63083e328ecc577"
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
