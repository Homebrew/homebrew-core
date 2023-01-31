class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.16.2",
      revision: "3e5fd5a1d70ea535ad5d18fb66a76c5cce905876"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5afa237a7350505f2172344bb69b2b10cf78160454086f60e7d29f373daa03f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5afa237a7350505f2172344bb69b2b10cf78160454086f60e7d29f373daa03f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5afa237a7350505f2172344bb69b2b10cf78160454086f60e7d29f373daa03f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b4b419e4842fef13eca2adca70eda55fb8352c87a0a14ad830cd63b899809e7c"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b419e4842fef13eca2adca70eda55fb8352c87a0a14ad830cd63b899809e7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4b419e4842fef13eca2adca70eda55fb8352c87a0a14ad830cd63b899809e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da0d3d86a5598e83b3b4b34fae54d742e460ffa0f4841b9869c75b5102205cb6"
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
