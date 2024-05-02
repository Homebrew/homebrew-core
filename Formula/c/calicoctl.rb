class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.27.3",
      revision: "638464f946657417dd4900724112eb844ce5be03"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a228b3568bdcd17e165564dc1d9a6a19324a369edf44ebace996716813864bba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40ca509518ee0eadbeee824b9dc52080e478b148fbc3324153bacce10393851b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26811ca1a9d3a6f7ec177cee5444c6ba5767254ef4ddc3fd102da17fed38a6fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "40f497b64a93ba22d1c380beb1c64b7f36ca2c72555dc30b2b8b179cdc6c0bd7"
    sha256 cellar: :any_skip_relocation, ventura:        "60d97b06fa4625adad9976c5bb61e0fb376d1e32623a53aa0f932876d13676e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ebb9bd7d593edadc7fb27e601218139209275b6478b628318efc7a6598640427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc288ee6020d9cc43aacd113c8d31f8b53a1d902c7c91795c6b4d28d65b13542"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
