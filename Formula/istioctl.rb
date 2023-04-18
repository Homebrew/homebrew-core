class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.17.2",
      revision: "3e857775086a061d12ee445f32a0b35ea17c8488"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e08ac41b93f8c8a1d2295c8fad988892e2aed52d0242c93b51784000a6513562"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e08ac41b93f8c8a1d2295c8fad988892e2aed52d0242c93b51784000a6513562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e08ac41b93f8c8a1d2295c8fad988892e2aed52d0242c93b51784000a6513562"
    sha256 cellar: :any_skip_relocation, ventura:        "df144fab9c5756abc1289e204a74b405f99cc48e7e5298a9fe904c0a6292c048"
    sha256 cellar: :any_skip_relocation, monterey:       "38771aa90c5efcc4aaea60ab409ca89688e33bec2051e3a7de4b8816df407247"
    sha256 cellar: :any_skip_relocation, big_sur:        "38771aa90c5efcc4aaea60ab409ca89688e33bec2051e3a7de4b8816df407247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9364c3aad6bd259619c1966ea3f37543d50362b01e26e99597b0b5773ebeedd"
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
