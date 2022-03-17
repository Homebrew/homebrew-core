class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.13.2",
      revision: "91533d04e894ff86b80acd6d7a4517b144f9e19a"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cce2eb92bfe080812fe08ac0fc81c603ed59d622a70ffad40c5fd28e855ae362"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cce2eb92bfe080812fe08ac0fc81c603ed59d622a70ffad40c5fd28e855ae362"
    sha256 cellar: :any_skip_relocation, monterey:       "916147387e88be3f4dc1e4a783d1becc717a0c6d2f345a7b5a9096adfa933da8"
    sha256 cellar: :any_skip_relocation, big_sur:        "916147387e88be3f4dc1e4a783d1becc717a0c6d2f345a7b5a9096adfa933da8"
    sha256 cellar: :any_skip_relocation, catalina:       "916147387e88be3f4dc1e4a783d1becc717a0c6d2f345a7b5a9096adfa933da8"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  uses_from_macos "curl" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "bash")
    (bash_completion/"istioctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "zsh")
    (zsh_completion/"_istioctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"istioctl", "completion", "fish")
    (fish_completion/"istioctl.fish").write output
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
