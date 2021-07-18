class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.10.3",
      revision: "61313778e0b785e401c696f5e92f47af069f96d0"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5c49a8720d5bf52196694892b1d31388201653bf29b57045ad8f9d298235c0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "25ab8b1a917fdf167d0e1779e6bbba2131e837facdadc8d0bee3a12456e143be"
    sha256 cellar: :any_skip_relocation, catalina:      "25ab8b1a917fdf167d0e1779e6bbba2131e837facdadc8d0bee3a12456e143be"
    sha256 cellar: :any_skip_relocation, mojave:        "25ab8b1a917fdf167d0e1779e6bbba2131e837facdadc8d0bee3a12456e143be"
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
