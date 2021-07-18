class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.10.3",
      revision: "61313778e0b785e401c696f5e92f47af069f96d0"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80d826f9766cecd059aa528be3a813d2c76f3630902620dfcb12f3736523fc62"
    sha256 cellar: :any_skip_relocation, big_sur:       "0563166422441d3d5cb77d6ffa6542558c12e463befc04d6a144457ddf80bb72"
    sha256 cellar: :any_skip_relocation, catalina:      "0563166422441d3d5cb77d6ffa6542558c12e463befc04d6a144457ddf80bb72"
    sha256 cellar: :any_skip_relocation, mojave:        "0563166422441d3d5cb77d6ffa6542558c12e463befc04d6a144457ddf80bb72"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  # Build script bin/init.sh runs curl command with `--retry-connrefused`,
  # which needs curl >= 7.52. Can remove if Linux CI default curl is updated.
  uses_from_macos "curl" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = "darwin"
    on_linux do
      os = "linux"
    end
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    ENV["TARGET_ARCH"] = arch

    system "make", "istioctl", "istioctl.completion"
    cd "out/#{os}_#{arch}" do
      bin.install "istioctl"
      bash_completion.install "release/istioctl.bash"
      zsh_completion.install "release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
