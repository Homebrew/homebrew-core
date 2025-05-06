class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.167.0",
      revision: "0070add9bd24c1117812e07313dada740a196116"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a129deb12ea066242a76a12b9368ba23cdfb6450395678f811d234689d3d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa1a5b0d996049cca4765b818ef7186eaea0b9e6a0af3609058a8ec3315d720"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94a07899763a974582ba7999e4fc1ca8b3a5d44045254b851989372674349e23"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ef7bf4b0c4bdcd7fe6352391d1f588e77eabfb66ebd5f3898d92c0b3809567d"
    sha256 cellar: :any_skip_relocation, ventura:       "050e61e46160add68a21fb795fbfb21cc292880a7d480b1f6ff0127d8f19a3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1b0f906c756c0df2da16bdcd859fe6a19e09d9c37a2ae1b284990695182a77a"
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
