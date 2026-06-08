class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.30.1.tar.gz"
  sha256 "3953e0e28fadadda5f77577084b7b5efda1f0ab63d88e676139d5457f4e2df0f"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afc26f268c8ae29c0f306dcd9e4e0c18e64cf85ad7d7c3885a9d635a432d3131"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e4d1b8fe253acf4f98b267ae3d5744a6ccc42c5d17c00cf00f4c3aece3cf07d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "769105aad2eccb8bfa0180dde7c71c28504106c41d49686c8b31b321a9a392f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9762c6764a175949f50f8705dabd8c586a4f163d0d0c33fcf6667951e0f18459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e00b638e3831b639858940c17c31dfce27c39f5235893c32b52cea4dd747dc"
    sha256 cellar: :any,                 x86_64_linux:  "5e540ac8c74f6a51a55b0a64e3f4add97fd586cc37f50f0a2628465128d94de0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", shell_parameter_format: :cobra)
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
