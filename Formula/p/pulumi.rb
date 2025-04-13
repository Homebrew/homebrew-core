class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.162.0",
      revision: "1f52815bcfe5f1e9307ebe6f342563283f5bc35e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622779b64520ec61c6fb2e0dedca45b2b771373bd9238ce2e43f09cf9701592d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2420b92522906531239fb76b90bb28fd22efb34115bf7751bcb3752e543ef366"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcef89f2a99ad14a2ede65b7864c0c2a1174bd5184143c5b79822916096e3f45"
    sha256 cellar: :any_skip_relocation, sonoma:        "edebaffac4a6e229f9da10da1ae92d73d428a01a8a896036c50bbd66dbfbd062"
    sha256 cellar: :any_skip_relocation, ventura:       "ba67c0e0a18eb6acc3ed4d1241e48bc6915091509ef2d8f915568ad25d85a97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d99913cdf19a1fcf51afc6d9318c55f27f1c86bb1f2e8f9076cb8a2954d9467d"
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
