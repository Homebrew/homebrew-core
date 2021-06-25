class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.10.2",
      revision: "25c4362d87b9946d6b59d39bf21c6c8a192d060f"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61efd0ee8af4f7caab646bbbff40e59fc1d2c3a85687f79475dd2cc67a2de06f"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a6680c6a86b32ff47d4b550f40109637d107bbdcf47df09ad13d553cb775c94"
    sha256 cellar: :any_skip_relocation, catalina:      "8a6680c6a86b32ff47d4b550f40109637d107bbdcf47df09ad13d553cb775c94"
    sha256 cellar: :any_skip_relocation, mojave:        "8a6680c6a86b32ff47d4b550f40109637d107bbdcf47df09ad13d553cb775c94"
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
