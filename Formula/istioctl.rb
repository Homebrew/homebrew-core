class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.18.0",
      revision: "697f4ff0fe6ee531bbd4f5f2a6b4b1f302c955a8"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47efcb9d2bf4d65f11ad38f7bf8c9d5264825d39f17d3276f8db48df30662af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47efcb9d2bf4d65f11ad38f7bf8c9d5264825d39f17d3276f8db48df30662af4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47efcb9d2bf4d65f11ad38f7bf8c9d5264825d39f17d3276f8db48df30662af4"
    sha256 cellar: :any_skip_relocation, ventura:        "0a12321eb2f5442b53cc9727745ca4a53141ae136dd836359bcea8c6f7d8548f"
    sha256 cellar: :any_skip_relocation, monterey:       "0a12321eb2f5442b53cc9727745ca4a53141ae136dd836359bcea8c6f7d8548f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a12321eb2f5442b53cc9727745ca4a53141ae136dd836359bcea8c6f7d8548f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dbd7e96569b73df3b74baf39a87ad0b10981424ff97fbdc9868411d9345e566"
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
