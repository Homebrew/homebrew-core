class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.12.2",
      revision: "af0d66fd0aa363e9a7b0164f3a94ba36252fe60f"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "415b3d9cd0c3882745612081c6f8227a45fcf66641fab6ff05b78bf659df1ac6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "415b3d9cd0c3882745612081c6f8227a45fcf66641fab6ff05b78bf659df1ac6"
    sha256 cellar: :any_skip_relocation, monterey:       "0b405fff1b1402972e60b28a58449faddd5d0860248adc98f1c47fd0ee938809"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b405fff1b1402972e60b28a58449faddd5d0860248adc98f1c47fd0ee938809"
    sha256 cellar: :any_skip_relocation, catalina:       "0b405fff1b1402972e60b28a58449faddd5d0860248adc98f1c47fd0ee938809"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  # Fix https://github.com/istio/istio/issues/35831
  # remove in next release
  patch do
    url "https://github.com/istio/istio/commit/6d9c69f10431bca2ee2beefcfdeaad5e5f62071b.patch?full_index=1"
    sha256 "47e175fc0ac5e34496c6c0858eefbc31e45073dad9683164f7a21c74dbaa6055"
  end

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
