class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "8db6ac377577a20711447f405b5712191c0bfb822d418280d31e98cee3c10b6a"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "207b2bc2e0835df2ac1717d0bd9bf136c7799a89d96d191125ba251c726d097c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f623d6dea4f0fa99a18b904ec0267df142c5e46934b6aa46c4ff39ede2152e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac834286ecdab614deba83fbfadc9dc8e66f9bd49772a344d3c313e8df4e04aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c7e86ee1ff931809a9aacd67dbefc5c18a28a22a6f32db50be813a43bb57db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970737d1df712f8faf0276e30656197ffba0a5776dfdeab2dd75595a7ce423e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b8cd6b4a4e0a73c4f63739133063f661218e474a3e70844ce3841623dd368b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
