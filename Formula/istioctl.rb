class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.13.1",
      revision: "5f3b5ed958ae75156f8656fe7b3794f78e94db84"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43daed1c35d702a0b68e0a0f3f66140794b3504e171d1cc21725c17424ed916d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43daed1c35d702a0b68e0a0f3f66140794b3504e171d1cc21725c17424ed916d"
    sha256 cellar: :any_skip_relocation, monterey:       "fb26ce49f32cc3991f83b95adefb27b5246d0cb030e32b40e63af17a2382a335"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb26ce49f32cc3991f83b95adefb27b5246d0cb030e32b40e63af17a2382a335"
    sha256 cellar: :any_skip_relocation, catalina:       "fb26ce49f32cc3991f83b95adefb27b5246d0cb030e32b40e63af17a2382a335"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

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
