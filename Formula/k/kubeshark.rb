class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.2.3.tar.gz"
  sha256 "c02a61a4d5d773712526230ef0d39f691d0253564ff56d2671685ea9d35e110b"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85a62db327208fbdc646cb0886339fb3cbf0ea05c2d099814a0686604863021f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c7da4d2c2c7b20f154e4d9563f39dd79707aa9dbc6f5b51b4abb9d3465b0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "350d51b46a973629daee8f8157cc68cdcedb8b332de7c3296b9db51d0bc5e195"
    sha256 cellar: :any_skip_relocation, sonoma:        "4206eb1da1ed99a25c90a7e687dcaa1e0e8cfc786d0b784a6bf27e00e60088f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07ce21ef99602e20d7ba07dc7d9b3347a6174ad9b39be6a71a33db29bed591a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f0e8ebe3f59bb66d85c34f478f495e6236750c636a015c570abb922b0a966b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
