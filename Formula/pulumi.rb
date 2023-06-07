class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.69.0",
      revision: "a742822ecfee4cba1a2fc1e8eccfb087e8372561"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed97e1acd5c89b024034dc40438d387164dd4c2e56c97d5cd54dcb2c94f34a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d237f537ab1b35e34553ab30e935ec9d34be3aa42a26786b002807d6bed743ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "970aa6b570be41ae4f246d7e6000fb14a61a1ae97f4717b0cf5733c8ad181e25"
    sha256 cellar: :any_skip_relocation, ventura:        "7c743bb2dac05a465385819e9c63841b9988ed97d5770916c66806b0115b1d2a"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c8d7662ba8fec8df239fed5e45723b84a99b9024adff3eaeb8035b0972070f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb0291ed1688d3f8618c1dfe880ea651c18e8da27222338dfcc3244dd06b451d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab04a11c9858d1c5c55faf24ff26bf254b35f1b72cf38b603066da51e3ec0da9"
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
