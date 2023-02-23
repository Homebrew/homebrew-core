class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.17.1",
      revision: "7d6d2adacf8dcee110a48450d537f8ad26c7225f"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71c7164896127fae0adc402e9004a3ee488553e7955230a8765192a5a06a56b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c7164896127fae0adc402e9004a3ee488553e7955230a8765192a5a06a56b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71c7164896127fae0adc402e9004a3ee488553e7955230a8765192a5a06a56b9"
    sha256 cellar: :any_skip_relocation, ventura:        "92bc5d41a940ea113bccdaa05b2e154447264f699cb9bf5311b046c10d79281d"
    sha256 cellar: :any_skip_relocation, monterey:       "92bc5d41a940ea113bccdaa05b2e154447264f699cb9bf5311b046c10d79281d"
    sha256 cellar: :any_skip_relocation, big_sur:        "92bc5d41a940ea113bccdaa05b2e154447264f699cb9bf5311b046c10d79281d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d956ea8e47d8c3020bbd27da64e65f06691ff7491afc6e8d328d2f619ac0958"
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
