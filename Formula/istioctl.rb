class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.11.4",
      revision: "9f6f03276054bb62a1b745630322314ef14969e8"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef7a6948dfebbdb0977a503c28b9ef64b137528303a18ddf7f76540a5d18bbbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cbe268156cc441de0775c2614beb3b19bd8e67b1a4e68043b2ba284f5315090"
    sha256 cellar: :any_skip_relocation, catalina:      "2cbe268156cc441de0775c2614beb3b19bd8e67b1a4e68043b2ba284f5315090"
    sha256 cellar: :any_skip_relocation, mojave:        "2cbe268156cc441de0775c2614beb3b19bd8e67b1a4e68043b2ba284f5315090"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    # make parallelization should be fixed in version > 1.11.4
    ENV.deparallelize
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    dirpath = if OS.linux?
      "linux_amd64"
    elsif Hardware::CPU.arm?
      # Fix missing "amd64" for macOS ARM in istio/common/scripts/setup_env.sh
      # Can remove when upstream adds logic to detect `$(uname -m) == "arm64"`
      ENV["TARGET_ARCH"] = "arm64"

      "darwin_arm64"
    else
      "darwin_amd64"
    end

    system "make", "istioctl", "istioctl.completion"
    cd "out/#{dirpath}" do
      bin.install "istioctl"
      bash_completion.install "release/istioctl.bash"
      zsh_completion.install "release/_istioctl"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
