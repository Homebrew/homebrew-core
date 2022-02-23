class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.13.1",
      revision: "5f3b5ed958ae75156f8656fe7b3794f78e94db84"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23da51cba08028aaf897df6b631e45efa191255d305a8e883d3aa6d17786fd3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23da51cba08028aaf897df6b631e45efa191255d305a8e883d3aa6d17786fd3c"
    sha256 cellar: :any_skip_relocation, monterey:       "8e510da31bddf611c0a6cfcbae233aa9fe055a927de60b98073c41ee88c4c689"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e510da31bddf611c0a6cfcbae233aa9fe055a927de60b98073c41ee88c4c689"
    sha256 cellar: :any_skip_relocation, catalina:       "8e510da31bddf611c0a6cfcbae233aa9fe055a927de60b98073c41ee88c4c689"
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
