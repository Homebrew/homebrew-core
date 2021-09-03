class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.11.2",
      revision: "96710172e1e47cee227e7e8dd591a318fdfe0326"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3495695cd8ffd91a7556803b8d81724522becf11f42459f41a168ecac16f0375"
    sha256 cellar: :any_skip_relocation, big_sur:       "c44a82896d9c46b335aadda3dcdf37b7eb2ba8df69f320317c93626e5e16dbb0"
    sha256 cellar: :any_skip_relocation, catalina:      "c44a82896d9c46b335aadda3dcdf37b7eb2ba8df69f320317c93626e5e16dbb0"
    sha256 cellar: :any_skip_relocation, mojave:        "c44a82896d9c46b335aadda3dcdf37b7eb2ba8df69f320317c93626e5e16dbb0"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    # make parallelization should be fixed in version > 1.11.2
    ENV.deparallelize
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
