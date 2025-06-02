class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.173.0",
      revision: "50cec32d651e73a8f19111281e06825547c109c4"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e047297a5cd724872e79a2bc1729b01a0e479290f31c83ef45771dfc2f68e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d60ac5fa5390a9afa1508272415239f4bfa53f164b7128c928a60e067956ca3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4103d271072e7bbb4a47b1898e3fefc63cd49c121ad289d53257e0776ca03ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "0602e3f3ec833622fac7983f27e70d856685473f54a04ecefce63e73d79719ae"
    sha256 cellar: :any_skip_relocation, ventura:       "cd729e0634a9b15c49dc5c81d294ab982a171b73da9b4bc7fd073def3cf73970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b144a46de4c82f64aae146166250be3f11e5f57624f7fc8332cc763c2bb0a4f8"
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
