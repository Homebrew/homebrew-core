class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.14.1",
      revision: "f59ce19ec6b63bbb70a65c43ac423845f1129464"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4aba25f4c2d3ab04306a63b33d6eff16d5db0d62426f837e82d9cdaf5f5ced7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4aba25f4c2d3ab04306a63b33d6eff16d5db0d62426f837e82d9cdaf5f5ced7"
    sha256 cellar: :any_skip_relocation, monterey:       "94a5ae68196a87bac80928d2e816bd89038a6a9bb3485ca7419292373820bc9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a5ae68196a87bac80928d2e816bd89038a6a9bb3485ca7419292373820bc9f"
    sha256 cellar: :any_skip_relocation, catalina:       "94a5ae68196a87bac80928d2e816bd89038a6a9bb3485ca7419292373820bc9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbdf0bdeb95cca91b24ecb2be448e7b6564b556bbfb8db6515e8e93aae0be5c4"
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
