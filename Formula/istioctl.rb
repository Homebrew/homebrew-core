class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.17.1",
      revision: "7d6d2adacf8dcee110a48450d537f8ad26c7225f"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33b9ff4fd1c7f802e5e69849e102662fa1164c298446b672e153be368ae49fcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dea64dc293728b9eb9b16d2fefa8b994726c9819789a05e7615a1f4b2caaa4a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33b9ff4fd1c7f802e5e69849e102662fa1164c298446b672e153be368ae49fcd"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c25df236e1abccb92cba990eb6c1604f543e4f98cc0ca2380506c4142ca6ed"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c25df236e1abccb92cba990eb6c1604f543e4f98cc0ca2380506c4142ca6ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4c25df236e1abccb92cba990eb6c1604f543e4f98cc0ca2380506c4142ca6ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccb1711ef1cf7b3e7362f61e11495ef9a377918bcdb48b17fa51182a3cf208f8"
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
