class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.14.3",
      revision: "a95e01fe300e14a11e7e9503d4b2c196ab755fcf"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4acee1f58f1c09c9648cd0539cdfaaa8e7d25bb73a96a28b00f57d423253865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4acee1f58f1c09c9648cd0539cdfaaa8e7d25bb73a96a28b00f57d423253865"
    sha256 cellar: :any_skip_relocation, monterey:       "d014b4eb5244b221bf13f4beed68263b21e28022d7d63d2e026e2e040c1c6550"
    sha256 cellar: :any_skip_relocation, big_sur:        "d014b4eb5244b221bf13f4beed68263b21e28022d7d63d2e026e2e040c1c6550"
    sha256 cellar: :any_skip_relocation, catalina:       "d014b4eb5244b221bf13f4beed68263b21e28022d7d63d2e026e2e040c1c6550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d650c074006bee33a694955c8dac13fe03f12900f7c9483a2ec4564e89eb8771"
  end

  depends_on "go-bindata" => :build
  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
