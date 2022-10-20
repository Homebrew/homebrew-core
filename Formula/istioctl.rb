class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.15.2",
      revision: "b542583af7f8240ad0c9cab56eb9f8d55e1357ab"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc1f2097974290906a81c9113f9da3dcc68ae65158c2cf797dbaa7b8ac090d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc1f2097974290906a81c9113f9da3dcc68ae65158c2cf797dbaa7b8ac090d4e"
    sha256 cellar: :any_skip_relocation, monterey:       "235c4f96b924156e9814639ad7f461b26d5b993e71223df9e034a80faa9ed6e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "235c4f96b924156e9814639ad7f461b26d5b993e71223df9e034a80faa9ed6e9"
    sha256 cellar: :any_skip_relocation, catalina:       "235c4f96b924156e9814639ad7f461b26d5b993e71223df9e034a80faa9ed6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba723b8869ecfdc0edd4aa58df99815329229e48c03ae254fc1ddccd8732059b"
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
