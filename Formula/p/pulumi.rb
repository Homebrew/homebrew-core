class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.115.2",
      revision: "95f06deccd0fc1d1bf04108a8a5ec1722e7bc039"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2e7f09a47fa56076b0015572c875447cadbc8d3b6a23cddab819b6e127a10df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b844a63078b73b9d1aa8b39678476cbeb007022e2c8ec2e95d7b550dcd59319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eea47834d5f63e87b72206025aac2c18a737b8e64f083782d1899ff7dcadb37"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c6500778e79e6a98fe8452632281e4e25fac2bc978bcbce68cc4578508faa27"
    sha256 cellar: :any_skip_relocation, ventura:        "896307578593ce2a947c510c1f9d933594b85a46d7fbb377b86ddf36f4f278d5"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea6f85aded9bfe26bf651a2662dbc06bc4f8413ce9fa58ce1d1b9d3ed9f9ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffef1a991279809213ac36f79c07adbd29314580f462f937c1eaec1eece6c2d9"
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
