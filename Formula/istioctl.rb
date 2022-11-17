class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.16.0",
      revision: "8f2e2dc5d57f6f1f7a453e03ec96ca72b2205783"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed202e76d64ba68dd3f141168be8417a64a223b6de60c10d094457e940d9a964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed202e76d64ba68dd3f141168be8417a64a223b6de60c10d094457e940d9a964"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed202e76d64ba68dd3f141168be8417a64a223b6de60c10d094457e940d9a964"
    sha256 cellar: :any_skip_relocation, ventura:        "05f4c2b17dccea5b2fee5ba6fffbe6182ddcb5c8000e9f65d49af0eecfca75be"
    sha256 cellar: :any_skip_relocation, monterey:       "05f4c2b17dccea5b2fee5ba6fffbe6182ddcb5c8000e9f65d49af0eecfca75be"
    sha256 cellar: :any_skip_relocation, big_sur:        "05f4c2b17dccea5b2fee5ba6fffbe6182ddcb5c8000e9f65d49af0eecfca75be"
    sha256 cellar: :any_skip_relocation, catalina:       "05f4c2b17dccea5b2fee5ba6fffbe6182ddcb5c8000e9f65d49af0eecfca75be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05515fb1a65fb8531c556e50a7f20e464d3bd275d1d713aefde06cb13c56bfb9"
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
