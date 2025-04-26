class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.165.0",
      revision: "372cbc1020245a06ac3349b358c264d40f180fdb"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ebba29e2b699675eb8443fb86f618138938a20f7b59d57f659185a64d631a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c8ccf6231cf887d4e818a248dc3b39b0155fe597322088acbbb23e46ad1f269"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4492785ebf58c6a762aee840513ab46ae56f2b0478d1922a54d351458ee5ff78"
    sha256 cellar: :any_skip_relocation, sonoma:        "5106aa54b5b3cf2cdf701bc7cefb5177c5cbf3413a867d51487803933f4f049c"
    sha256 cellar: :any_skip_relocation, ventura:       "7080cec09c352c3c73fa4e03c579bc39464c89981837019b8fb93c6332654386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58998ba0caab1bbdc434db00d09e027b84554d11a664837220989bf61714f281"
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
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end
