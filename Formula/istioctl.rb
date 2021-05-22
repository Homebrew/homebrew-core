class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.10.0",
      revision: "d26cba7e341587453ffeb978f5cf6fbc32f346f8"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61d774242dc049cdb93a8d65ad2485bdea34d3433ff994162d574b791472d7f0"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    dirpath = nil
    on_macos do
      if Hardware::CPU.arm?
        # Fix missing "amd64" for macOS ARM in istio/common/scripts/setup_env.sh
        # Can remove when upstream adds logic to detect `$(uname -m) == "arm64"`
        ENV["TARGET_ARCH"] = "arm64"

        dirpath = "darwin_arm64"
      else
        dirpath = "darwin_amd64"
      end
    end
    on_linux do
      dirpath = "linux_amd64"
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
