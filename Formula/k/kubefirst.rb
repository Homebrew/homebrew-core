class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "302a7292141502dd5cc43e2be198a04a7338c73f1a1163574e449cf9ece8ba59"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbda1040d8682beb3a7419d1453566d1c798b14594d36f3c387a0ef1be063dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79ec17a9b3aad6a739edd3e66ef9b7ce7fbd37b752384abf2beb8e2597cb6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f746f991661bc6d11d4f346078dd06ff87a10c56ce2bfb412046edeffe5d16"
    sha256 cellar: :any_skip_relocation, sonoma:        "dae5e4bb1983e63fe154c0ffa483c25cec566ec1b2236bc7816b4a14bfa6090b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52712a3096162506ad145340cd37660dd947d0ac3fba18ea82480b0ccd281bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4748c9b855ac1e7756b0c8f6411349f3f6165eee8277e3969e25e1b9b95ebac2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_path_exists testpath/".k1/logs"

    output = shell_output("#{bin}/kubefirst version 2>&1")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
