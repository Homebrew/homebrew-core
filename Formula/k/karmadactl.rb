class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "9cdadefcbb0eecee1d80eddea81783f93846c49fb2b5adfa1b88fe5482c0fe2e"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b38e62a9cf021059fe1f219958170ffb48f5f5eb12cb67ece09b8fe3656f73f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bb0feb02fa08595b1ea8c7d2076725ef39eaf851db2c1268132bd99cc1456c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ef0610f599e491a59e45f915e6598db37c170ecd81697a207d69d166a86d5b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "181acf55cf8392f93152c1e2f251f8cedc5da2e71e6404b62b23abbe91801c34"
    sha256 cellar: :any_skip_relocation, ventura:        "e7f66717d93c520167e2b2dace00582e4e36c5b44e727e2da1efd8dc564d49bd"
    sha256 cellar: :any_skip_relocation, monterey:       "789e9922ad54162924ffa0554a14fc5e197f20c82a721664feee80c2cd6385b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2130ec7ee3ff68b0d18d7e7353b0d4b3b3a1eea2cc48e880af476cb9ccb9069"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
