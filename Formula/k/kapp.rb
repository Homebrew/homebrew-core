class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.65.4.tar.gz"
  sha256 "96ef9346efd6fcfe087441a16ae17c0c27a4174311322d41dbfbbd8014a24cdf"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "303ff9670bfeb4e104b5bb1bd1b29f444ccc0042afc74d2f23e7b08fb1cfdb81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c219034d8b60b2d8b865076e48dd82588b3ad1c3fe3bdf5a8cde33b5956e19c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c219034d8b60b2d8b865076e48dd82588b3ad1c3fe3bdf5a8cde33b5956e19c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3c219034d8b60b2d8b865076e48dd82588b3ad1c3fe3bdf5a8cde33b5956e19c"
    sha256 cellar: :any_skip_relocation, sonoma:            "5520b982838c60fbfb80a10eb249dd0f3a3c5e08f268e978cc60c25f8f2765ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29814e111c5e24f4f7df161ee04cd27c69f2cd583051d15b3ba141a304cca000"
    sha256 cellar: :any,                 x86_64_linux:      "a0675c094df1ddac15697ac010ed69de9c0833459cda047ba26d4331ef1e5818"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end
