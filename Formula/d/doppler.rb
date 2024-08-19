class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.69.0.tar.gz"
  sha256 "8001f8b3c672a3568093e16b93864709731f993af8b6621a77cedf8ec1e4e39d"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b5c70a9bed26dc6c3af92c44e10d855bbf50f2f68d6c6c94e2bad0f08ed0768"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47d88392fe47d9c2e33946914adbdeb01b709286c3a1f4204405313db4ca8f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46faf56a02a21dc3f50af35fbd3504f73467dbb333bfc9440252b487c708cc4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c81518153ab951051fe05e60f4926462726c0b4ac0254c648cb95c62e299e8fa"
    sha256 cellar: :any_skip_relocation, ventura:        "5424d40da6f9be139397382c5a61fd3a8cb56cb7f4d4531f80ba48b7efd441d6"
    sha256 cellar: :any_skip_relocation, monterey:       "f31ac4f906c86015bd1229b12ef66d2fa87b7bb0423706d98987bc8575d8ee48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa1082263a4ca75c42fd37d587f482f301ee9429a7eaecc442ebfcc2ada13a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
