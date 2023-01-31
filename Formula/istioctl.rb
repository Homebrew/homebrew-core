class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.16.2",
      revision: "3e5fd5a1d70ea535ad5d18fb66a76c5cce905876"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "988f889d6e40da2e265bd8f121a774517ed1caec6fd6a4bd06d7fa4d7927a5fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "988f889d6e40da2e265bd8f121a774517ed1caec6fd6a4bd06d7fa4d7927a5fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "988f889d6e40da2e265bd8f121a774517ed1caec6fd6a4bd06d7fa4d7927a5fe"
    sha256 cellar: :any_skip_relocation, ventura:        "ceb0b04710414ade50810ae910197098c7d2c407544e7a052ca1cf9d9ad7e25f"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb0b04710414ade50810ae910197098c7d2c407544e7a052ca1cf9d9ad7e25f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb0b04710414ade50810ae910197098c7d2c407544e7a052ca1cf9d9ad7e25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52561adc45776a74f00c50496de920d59f61254bec9967b739cca0321b964900"
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
