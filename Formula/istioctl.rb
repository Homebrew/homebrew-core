class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.15.3",
      revision: "bc21f4628d31fe5380569db6fa0e73517d956a0d"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7932a48efefacb8d58ebebbab6545a38464fd3cd8a6ab1e4f0e2d9d99f1ca403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7932a48efefacb8d58ebebbab6545a38464fd3cd8a6ab1e4f0e2d9d99f1ca403"
    sha256 cellar: :any_skip_relocation, monterey:       "2bbf969a5748a6bce1602ab226692e0332a441282ff26383b7aff50d236c83cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bbf969a5748a6bce1602ab226692e0332a441282ff26383b7aff50d236c83cb"
    sha256 cellar: :any_skip_relocation, catalina:       "2bbf969a5748a6bce1602ab226692e0332a441282ff26383b7aff50d236c83cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b83738f2f8a38a9df30c74e5fe5e5aa0459aba94823c8b07e84cd153887e7305"
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

    ENV.prepend_path "PATH", Formula["curl"].opt_bin if OS.linux?

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
