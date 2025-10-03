class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.60.0.tar.gz"
  sha256 "f68f8847c293aa183a96cab7a6a90f893fa37a173d9375694c757ca51c6ef5ff"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec5ee51a2c1772eed2f4b1148c6737a80b4502aba700e92e67097c440a4871ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec5ee51a2c1772eed2f4b1148c6737a80b4502aba700e92e67097c440a4871ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec5ee51a2c1772eed2f4b1148c6737a80b4502aba700e92e67097c440a4871ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8123383a41ba032678cca897a53eaf0a5a30384b643ba070f27876695d844236"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "622d287824e27481564166fccd2edcf1193a68140a00ade93545815fcc4806bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf06c0cbd9ecc4aa9bb525f9ac0e1b5698ebc5746792053e56d43a19ae08bd21"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
